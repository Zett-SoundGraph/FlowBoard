import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:flow_board/core/constants/local_subnet_resolver.dart';
import 'package:flow_board/core/constants/network.dart';
import 'package:flow_board/core/utils/log.dart';
import 'package:flow_board/domain/entities/index.dart';

abstract interface class IMqttDataSource {
  Stream<bool> get connectionStream;
  Stream<RawMqttMessage> get messageStream;
  Future<void> connect();
  void dispose();
}

@Singleton(as: IMqttDataSource)
class MqttDataSource implements IMqttDataSource {
  static const _tag = 'MqttClient';
  // Every topic, unfiltered — this app's purpose is watching the whole
  // broker's traffic, not just the subset FlowHub itself cares about.
  static const _topicWildcardAll = '#';
  static const _heartbeatInterval = Duration(seconds: 5);
  static const _topicHeartbeatPrefix = 'beta/system/heartbeat/';
  static String get _topicHeartbeat =>
      '$_topicHeartbeatPrefix${NetworkConstants.mqttDeviceId}';

  MqttServerClient? _client;
  Timer? _heartbeatTimer;
  Timer? _retryTimer;
  // autoReconnect only takes over once a client has connected successfully
  // at least once — it never fires for a connect() call that fails outright
  // (e.g. broker/network not up yet), so a failed FIRST attempt would
  // otherwise never retry on its own. Most visible at boot: a startup-app
  // launch can race Android's own network stack coming up, lose that race
  // once, and then sit disconnected forever until someone manually
  // relaunches the app (by which point the network is already up, so it
  // "just works" and looks unrelated to this).
  static const _retryInterval = Duration(seconds: 5);

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  final StreamController<RawMqttMessage> _messageController =
      StreamController<RawMqttMessage>.broadcast();

  @override
  Stream<bool> get connectionStream => _connectionController.stream;

  @override
  Stream<RawMqttMessage> get messageStream => _messageController.stream;

  /// Connects to the broker and subscribes to every topic.
  @override
  Future<void> connect() async {
    if (_client?.connectionStatus?.state == MqttConnectionState.connected) {
      Log.d(_tag, 'connect() called while already connected — ignoring');
      return;
    }
    _retryTimer?.cancel();
    _client?.disconnect();

    // Waits for this device's own subnet to be confirmed before ever
    // dialing out — a brand-new site (whose subnet doesn't match
    // NetworkConstants.mqttBrokerHost's currently-deployed-site fallback)
    // would otherwise always waste a doomed first attempt before
    // self-correcting on a later retry.
    await LocalSubnetResolver.ready;

    final client = MqttServerClient(
      NetworkConstants.mqttBrokerHost,
      NetworkConstants.mqttDeviceId,
    );
    client.port = NetworkConstants.mqttBrokerPort;
    client.keepAlivePeriod = 15;
    client.autoReconnect = true;
    client.logging(on: false);
    client.onConnected = () {
      Log.d(_tag,
          'Connected to broker (${NetworkConstants.mqttBrokerHost}:${NetworkConstants.mqttBrokerPort})');
      _connectionController.add(true);
    };
    client.onDisconnected = () {
      Log.d(_tag, 'Disconnected from broker');
      _connectionController.add(false);
    };
    client.onAutoReconnect = () => Log.d(_tag, 'Auto-reconnecting to broker');
    client.onAutoReconnected = () => Log.d(_tag, 'Auto-reconnect sequence completed');

    client.connectionMessage = MqttConnectMessage()
        .withClientIdentifier(NetworkConstants.mqttDeviceId)
        .authenticateAs(
          NetworkConstants.mqttUsername,
          NetworkConstants.mqttPassword,
        );

    try {
      await client.connect();
    } catch (e) {
      Log.e(_tag, 'Connect error: $e — retrying in ${_retryInterval.inSeconds}s');
      client.disconnect();
      _scheduleRetry();
      return;
    }

    if (client.connectionStatus?.state != MqttConnectionState.connected) {
      Log.e(_tag,
          'Connection failed: ${client.connectionStatus} — retrying in ${_retryInterval.inSeconds}s');
      client.disconnect();
      _scheduleRetry();
      return;
    }

    _client = client;
    client.subscribe(_topicWildcardAll, MqttQos.atMostOnce);
    client.updates!.listen(_handleMessage);

    _startHeartbeat();
  }

  void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryTimer = Timer(_retryInterval, () => unawaited(connect()));
  }

  void _handleMessage(List<MqttReceivedMessage<MqttMessage>> events) {
    for (final event in events) {
      try {
        final message = event.payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(message.payload.message);
        _messageController.add((
          topic: event.topic,
          payload: payload,
          receivedAt: DateTime.now(),
        ));
      } catch (e) {
        Log.e(_tag, 'Message handling error on ${event.topic}: $e');
      }
    }
  }

  /// Publishes its own presence heartbeat, same as every other device on the
  /// fleet — lets Device Management's "Flow Board" row light up.
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _publishHeartbeat();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) => _publishHeartbeat());
  }

  void _publishHeartbeat() {
    final client = _client;
    if (client == null ||
        client.connectionStatus?.state != MqttConnectionState.connected) {
      return;
    }
    final builder = MqttClientPayloadBuilder();
    builder.addUTF8String(
      '{"status":"online","deviceName":"Flow Board","deviceId":"${NetworkConstants.mqttDeviceId}"}',
    );
    client.publishMessage(
      _topicHeartbeat,
      MqttQos.atMostOnce,
      builder.payload!,
      retain: true,
    );
  }

  @override
  void dispose() {
    _heartbeatTimer?.cancel();
    _retryTimer?.cancel();
    _client?.disconnect();
    _connectionController.close();
    _messageController.close();
    Log.d(_tag, 'Disposed');
  }
}
