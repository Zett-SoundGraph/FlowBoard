import 'package:flow_board/core/constants/local_subnet_resolver.dart';

class NetworkConstants {
  // Every Cafe Beta device on one site shares a subnet (see
  // LocalSubnetResolver) — only the last octet is fixed per role, so a new
  // site (a different third octet) needs no code change or reinstall, just
  // its router pre-configured with the broker's address reserved.
  static String get mqttBrokerHost => '${LocalSubnetResolver.prefix}.240';
  static const int mqttBrokerPort = 1883;
  static const String mqttUsername = String.fromEnvironment('MQTT_USERNAME');
  static const String mqttPassword = String.fromEnvironment('MQTT_PASSWORD');

  // Matches the deviceId reserved for this device in FlowHub's
  // device_management_screen.dart (_flowBoardDeviceId) — keeping the two in
  // sync means that row lights up as soon as this app connects, with no
  // further changes needed on the FlowHub side. Stays a lowercase/hyphenated
  // slug (not "Flow Board") because this gets embedded directly into MQTT
  // topic paths (beta/system/heartbeat/<mqttDeviceId>) — every other topic
  // in the protocol is all-lowercase/no-space, so a space here would be the
  // odd one out.
  static const String mqttDeviceId = 'flow-board';
}
