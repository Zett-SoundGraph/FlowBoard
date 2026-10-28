/// A topic's display metadata for the log dump — an icon asset + human
/// title.
typedef MqttTopicSource = ({String icon, String title});

const _flowhubIcon = 'assets/images/flowhub.png';
const _pickupTableIcon = 'assets/images/pickuptable.png';
const _cayeIcon = 'assets/images/Caye.png';
const _raspberryPiIcon = 'assets/images/raspberry.png';
const _fallbackIcon = 'assets/images/monitor.png';

const heartbeatTopicPrefix = 'beta/system/heartbeat/';
const leaderUpdateTopic = 'beta/flowhub/leader/update';

/// Every real topic the whole fleet uses (see the MQTT protocol sheets).
/// beta/rpi/object and beta/flowhub/object were an earlier, different name
/// planned for the Raspberry Pi's ToF migration but never built — it
/// shipped instead as beta/tof/objects / beta/tof/control (PiMqttManager,
/// ToF-백업파일/include/PiMqtt_Man.h), listed below.
/// A topic never seen before still displays fine via the raw-topic
/// fallback — nothing received ever goes undisplayed, this just makes the
/// known ones read nicely.
MqttTopicSource resolveMqttTopicSource(String topic) {
  if (topic.startsWith(heartbeatTopicPrefix)) {
    final deviceId = topic.substring(heartbeatTopicPrefix.length);
    // Not a fixed id like the cases below — kiosk builds are tested under
    // varying names (kiosk-01, flow-kiosk, ...), so any of them reads nicely
    // as "kiosk" instead of falling through to the raw-id default.
    if (deviceId.toLowerCase().contains('kiosk')) {
      return (icon: _fallbackIcon, title: 'kiosk');
    }
    switch (deviceId) {
      case 'flowhub-leader':
        return (icon: _flowhubIcon, title: 'flowhub leader');
      case 'flowhub-follower-01':
      case 'flowhub-follower-02':
        return (icon: _flowhubIcon, title: 'flowhub follower');
      case 'flow-pickup-table':
        return (icon: _pickupTableIcon, title: 'flow pickup table');
      case 'flow-tof-camera':
        return (icon: _raspberryPiIcon, title: 'flow tof camera');
      case 'flow-pickup-board':
        return (icon: _fallbackIcon, title: 'flow pickup board');
      case 'flow-board':
        return (icon: _fallbackIcon, title: 'flow board');
      case 'flow-qr-reader-brew':
        return (icon: _fallbackIcon, title: 'flow qr reader brew');
      case 'flow-qr-reader-call':
        return (icon: _fallbackIcon, title: 'flow qr reader call');
      case 'flow-qr-reader-pickup':
        return (icon: _fallbackIcon, title: 'flow qr reader pickup');
      default:
        return (icon: _fallbackIcon, title: deviceId);
    }
  }

  // Dynamic segment ({followerId}) — matched by prefix/suffix rather than
  // a fixed case.
  if (topic.startsWith('beta/flowhub/follower/') && topic.endsWith('/update')) {
    return (icon: _flowhubIcon, title: 'flowhub follower sync request');
  }

  switch (topic) {
    case 'beta/kiosk/order':
      return (icon: _fallbackIcon, title: 'kiosk order');
    case leaderUpdateTopic:
      return (icon: _flowhubIcon, title: 'flowhub leader update');
    case 'beta/flowhub/board/update':
      return (icon: _flowhubIcon, title: 'board update');
    case 'beta/flowhub/kiosk/update':
      return (icon: _flowhubIcon, title: 'kiosk update');
    case 'beta/flowhub/caye/fault':
      return (icon: _cayeIcon, title: 'Caye Coffee Machine (Fault)');
    case 'beta/flowhub/caye/status':
      return (icon: _cayeIcon, title: 'Caye Coffee Machine (Status)');
    case 'beta/flowhub/caye/rinsing':
      return (icon: _cayeIcon, title: 'Caye Coffee Machine (Rinsing)');
    case 'beta/flowhub/caye/cleaning':
      return (icon: _cayeIcon, title: 'Caye Coffee Machine (Cleaning)');
    case 'beta/qr/order':
      return (icon: _fallbackIcon, title: 'flow qr reader brew');
    case 'beta/qr/complete':
      return (icon: _fallbackIcon, title: 'flow qr reader call');
    case 'beta/qr/customer':
      return (icon: _fallbackIcon, title: 'flow qr reader pickup');
    case 'beta/pickuptable/pickup':
      return (icon: _pickupTableIcon, title: 'flow pickup table');
    case 'beta/tof/objects':
      return (icon: _raspberryPiIcon, title: 'flow tof camera (ToF objects)');
    case 'beta/tof/control':
      return (icon: _raspberryPiIcon, title: 'flow tof camera (control)');
    default:
      return (icon: _fallbackIcon, title: topic);
  }
}
