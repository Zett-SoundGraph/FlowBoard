import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:flow_board/domain/entities/index.dart';
import 'package:flow_board/domain/usecases/index.dart';
import 'package:flow_board/presentation/cubit/flow_board_state.dart';

@injectable
class FlowBoardCubit extends Cubit<FlowBoardState> {
  FlowBoardCubit(this._connect, this._observeMessages)
      : super(FlowBoardState(appStartedAt: DateTime.now())) {
    _messageSubscription = _observeMessages().listen(_handleMessage);
    unawaited(_connect());
    // Nothing else re-renders the uptime clock on its own since it isn't
    // driven by an MQTT event — this is what actually ticks it forward.
    _clockTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => emit(state.copyWith(clockTick: state.clockTick + 1)),
    );
  }

  // Unbounded growth would eventually slow the list down over a full
  // exhibition day — old entries are dropped past this count.
  static const _maxEntries = 300;

  // Matches FlowHub's own Device Management screen threshold
  // (device_management_screen.dart) for what counts as still "alive".
  static const _heartbeatStaleAfter = Duration(seconds: 60);

  // Every FleetDevice.leaderStateField value that's actually meaningful in
  // beta/flowhub/leader/update's payload — a malformed/unrelated message on
  // this topic just leaves whatever was last known untouched.
  static const _leaderStateFields = ['isPrinterConnected', 'isCayeConnected'];

  final ConnectUsecase _connect;
  final ObserveMessagesUsecase _observeMessages;

  StreamSubscription<RawMqttMessage>? _messageSubscription;
  Timer? _clockTimer;

  void _handleMessage(RawMqttMessage message) {
    final deviceLastSeen = Map<String, DateTime>.from(state.deviceLastSeen);
    final leaderState = Map<String, bool>.from(state.leaderState);

    if (message.topic == leaderUpdateTopic) {
      _parseLeaderUpdate(message.payload, leaderState);
    }
    if (message.topic.startsWith(heartbeatTopicPrefix)) {
      deviceLastSeen[message.topic.substring(heartbeatTopicPrefix.length)] =
          message.receivedAt;
    }

    final entries = [message, ...state.entries];
    if (entries.length > _maxEntries) entries.removeLast();

    emit(state.copyWith(
      entries: entries,
      totalMessagesReceived: state.totalMessagesReceived + 1,
      deviceLastSeen: deviceLastSeen,
      leaderState: leaderState,
    ));
  }

  void _parseLeaderUpdate(String payload, Map<String, bool> leaderState) {
    try {
      final json = jsonDecode(payload) as Map<String, dynamic>;
      for (final field in _leaderStateFields) {
        final value = json[field];
        if (value is bool) leaderState[field] = value;
      }
    } catch (_) {
      // Not valid JSON, or not shaped like LeaderUpdateMessage — ignore.
    }
  }

  bool _isHeartbeatFresh(String deviceId) {
    final lastSeen = state.deviceLastSeen[deviceId];
    return lastSeen != null &&
        DateTime.now().difference(lastSeen) <= _heartbeatStaleAfter;
  }

  bool isDeviceConnected(FleetDevice device) {
    final field = device.leaderStateField;
    if (field != null) {
      // Only trust the cached leader-broadcast value while the Leader
      // itself is confirmed alive — otherwise a Leader that went offline
      // would leave its last-known (retained) values looking permanently
      // "Connected" forever.
      if (!_isHeartbeatFresh('flowhub-leader')) return false;
      return state.leaderState[field] ?? false;
    }
    final prefix = device.idPrefix?.toLowerCase();
    if (prefix != null) {
      final now = DateTime.now();
      // contains, not startsWith — see FleetDevice.idPrefix's doc comment.
      return state.deviceLastSeen.entries.any((e) =>
          e.key.toLowerCase().contains(prefix) &&
          now.difference(e.value) <= _heartbeatStaleAfter);
    }
    return device.heartbeatDeviceIds.any(_isHeartbeatFresh);
  }

  @override
  Future<void> close() {
    unawaited(_messageSubscription?.cancel());
    _clockTimer?.cancel();
    return super.close();
  }
}
