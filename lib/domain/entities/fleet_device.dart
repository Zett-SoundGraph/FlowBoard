/// One device tracked in the "Device Fleet" grid.
///
/// [heartbeatDeviceIds] lists every `beta/system/heartbeat/{id}` deviceId
/// that counts as this device being alive (more than one only for Flow Hub
/// Follower, which can run as either follower01 or follower02 — either
/// being fresh counts).
///
/// Label Printer / Caye Machine never publish a heartbeat of their own —
/// their connection state lives inside FlowHub Leader's own `KdsState`
/// (native TCP connections KDS itself owns). But the Leader already
/// broadcasts exactly that state to every Follower on
/// `beta/flowhub/leader/update` (fields `isPrinterConnected`/
/// `isCayeConnected`), and Flow Board's `#` wildcard subscription already
/// receives that same message — it just needs to read the field, the same
/// way a real Follower does. [leaderStateField] names that field for these
/// two; null for every heartbeat-tracked device (including Raspberry Pi,
/// below — it used to be a `leaderStateField` too, back when its
/// connection lived inside KDS's own WebSocket server, but it moved to a
/// direct MQTT heartbeat once its ToF/control traffic moved off that
/// WebSocket relay onto MQTT — see device_management_screen.dart's
/// _raspberryPiDeviceId doc comment in the flowhub project for the full
/// story).
class FleetDevice {
  final String label;
  final String icon;
  final List<String> heartbeatDeviceIds;
  final String? leaderStateField;
  // When set, ANY heartbeat deviceId starting with this (case-insensitive)
  // counts as this device being alive, instead of requiring an exact match
  // against [heartbeatDeviceIds] — for a role like Kiosk where multiple
  // differently-named physical/test units (kiosk-01, kioskTest02, ...)
  // should all count as "the kiosk", not just one fixed id.
  final String? idPrefix;

  const FleetDevice({
    required this.label,
    required this.icon,
    this.heartbeatDeviceIds = const [],
    this.leaderStateField,
    this.idPrefix,
  });
}

/// The fixed 12-device fleet (matches FlowHub's own Device Management screen
/// list/order exactly — device_management_screen.dart).
const List<FleetDevice> kFleetDevices = [
  FleetDevice(
    label: 'Flow Hub Leader',
    icon: 'assets/images/flowhub.png',
    heartbeatDeviceIds: ['flowhub-leader'],
  ),
  FleetDevice(
    label: 'Flow Hub Follower',
    icon: 'assets/images/flowhub.png',
    heartbeatDeviceIds: ['flowhub-follower01', 'flowhub-follower02'],
  ),
  FleetDevice(
    label: 'Scanner Brew',
    icon: 'assets/images/monitor.png',
    heartbeatDeviceIds: ['scanner-order-01'],
  ),
  FleetDevice(
    label: 'Scanner Call',
    icon: 'assets/images/monitor.png',
    heartbeatDeviceIds: ['scanner-complete-01'],
  ),
  FleetDevice(
    label: 'Scanner Pickup',
    icon: 'assets/images/monitor.png',
    heartbeatDeviceIds: ['scanner-customer-01'],
  ),
  FleetDevice(
    label: 'Pickup Table',
    icon: 'assets/images/pickuptable.png',
    heartbeatDeviceIds: ['Cafe Beta PickupTable'],
  ),
  FleetDevice(
    label: 'Kiosk',
    icon: 'assets/images/monitor.png',
    // Not a fixed id like the other rows — kiosk builds are tested under
    // varying names (kiosk-01, kioskTest02, ...), so this matches by
    // prefix instead (see FleetDevice.idPrefix).
    idPrefix: 'kiosk',
  ),
  FleetDevice(
    label: 'Pickup Board',
    icon: 'assets/images/monitor.png',
    heartbeatDeviceIds: ['Cafe Beta PickupBoard'],
  ),
  FleetDevice(
    label: 'Flow Board',
    icon: 'assets/images/monitor.png',
    heartbeatDeviceIds: ['Cafe Beta FlowBoard'],
  ),
  FleetDevice(
    label: 'Label Printer',
    icon: 'assets/images/print.png',
    leaderStateField: 'isPrinterConnected',
  ),
  FleetDevice(
    label: 'Raspberry Pi',
    icon: 'assets/images/raspberry.png',
    // Confirmed from ToF-백업파일's PiMqtt_Man.h: HEARTBEAT_DEVICE_ID — the
    // Pi now publishes beta/system/heartbeat/<this id> directly every 5s
    // (retained), same as every other MQTT device above (see
    // flowhub/device_management_screen.dart's _raspberryPiDeviceId, already
    // updated to match).
    heartbeatDeviceIds: ['Cafe Beta RaspberryPi'],
  ),
  FleetDevice(
    label: 'Caye Machine',
    icon: 'assets/images/Caye.png',
    leaderStateField: 'isCayeConnected',
  ),
];
