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
  // When set, ANY heartbeat deviceId CONTAINING this (case-insensitive,
  // anywhere in the string) counts as this device being alive, instead of
  // requiring an exact match against [heartbeatDeviceIds] — for a role like
  // Kiosk where multiple differently-named physical/test units (kiosk-01,
  // flow-kiosk, kioskTest02, ...) should all count as "the kiosk", not just
  // one fixed id.
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
  // heartbeatDeviceIds/idPrefix are lowercase/hyphenated slugs — they're
  // matched directly against incoming MQTT topic paths
  // (beta/system/heartbeat/<deviceId>), which are all-lowercase/no-space
  // throughout the protocol. `label` is the pretty on-screen text and is
  // free to use normal capitalization/spacing.
  FleetDevice(
    label: 'FlowHub Leader',
    icon: 'assets/images/flowhub.png',
    heartbeatDeviceIds: ['flowhub-leader'],
  ),
  FleetDevice(
    label: 'FlowHub Follower',
    icon: 'assets/images/flowhub.png',
    heartbeatDeviceIds: ['flowhub-follower-01', 'flowhub-follower-02'],
  ),
  FleetDevice(
    label: 'Flow QR Reader Brew',
    icon: 'assets/images/monitor.png',
    heartbeatDeviceIds: ['flow-qr-reader-brew'],
  ),
  FleetDevice(
    label: 'Flow QR Reader Call',
    icon: 'assets/images/monitor.png',
    heartbeatDeviceIds: ['flow-qr-reader-call'],
  ),
  FleetDevice(
    label: 'Flow QR Reader Pickup',
    icon: 'assets/images/monitor.png',
    heartbeatDeviceIds: ['flow-qr-reader-pickup'],
  ),
  FleetDevice(
    label: 'Flow Pickup Table',
    icon: 'assets/images/pickuptable.png',
    heartbeatDeviceIds: ['flow-pickup-table'],
  ),
  FleetDevice(
    label: 'Flow Kiosk',
    icon: 'assets/images/monitor.png',
    // Not a fixed id like the other rows — kiosk builds are tested under
    // varying names (kiosk-01, flow-kiosk, kioskTest02, ...), so this
    // matches any id CONTAINING "kiosk" instead (see FleetDevice.idPrefix).
    idPrefix: 'kiosk',
  ),
  FleetDevice(
    label: 'Flow Pickup Board',
    icon: 'assets/images/monitor.png',
    heartbeatDeviceIds: ['flow-pickup-board'],
  ),
  FleetDevice(
    label: 'Flow Board',
    icon: 'assets/images/monitor.png',
    heartbeatDeviceIds: ['flow-board'],
  ),
  FleetDevice(
    label: 'Label Printer',
    icon: 'assets/images/print.png',
    leaderStateField: 'isPrinterConnected',
  ),
  FleetDevice(
    label: 'Flow ToF Camera',
    icon: 'assets/images/raspberry.png',
    heartbeatDeviceIds: ['flow-tof-camera'],
  ),
  FleetDevice(
    label: 'Caye Machine',
    icon: 'assets/images/Caye.png',
    leaderStateField: 'isCayeConnected',
  ),
];
