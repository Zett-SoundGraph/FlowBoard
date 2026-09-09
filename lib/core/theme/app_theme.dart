import 'package:flutter/material.dart';

/// Font family registered in pubspec.yaml — same face KDS uses, kept
/// consistent across the fleet's screens.
const flowBoardFontFamily = 'LineSeedJP';

/// Design tokens for the log screen (figmaImage/FlowBoard.png).
class FlowBoardColors {
  const FlowBoardColors._();

  static const logBg = Color(0xFF05334A);
  static const timestamp = Color(0xFFE8674A);
  static const divider = Color(0x1FFFFFFF);
  static const bodyText = Color(0xDEFFFFFF);
  // Heartbeat log entries (title + body) render in this muted color instead
  // of the normal white/bodyText, so they read as background noise next to
  // real signals.
  static const heartbeatText = Color(0xFF87888A);

  // Header section (uptime/connected-clients/Messages + Device Fleet) — per
  // the exact Figma spec (figmaImage/FlowBoard.png). CSS #RRGGBBAA values
  // are re-expressed as Flutter's 0xAARRGGBB.
  static const headerBg = Color(0xFFFFF8EF);
  static const cardBg = Color(0xFFFFFCF7);
  static const cardBorder = Color(0x421A1C1E); // beta-black-black-26
  static const cardLabel = Color(0x941A1C1E); // beta-black-black-58
  static const cardValueDark = Color(0xFF1A1C1E); // beta-black-black-100
  static const cardValueNavy = logBg; // Beta-Primary-Blue-B6-Primary, #05334A
  static const cardValueBlueB5 = Color(0xFF235973); // Beta-Primary-Blue-B5
  static const cardValueMuted = Color(0x611A1C1E); // beta-black-black-38
  static const pillBg = Color(0xFFE5F0F7); // Beta-Primary-Blue-B2
  static const pillConnected = Color(0xFF5FA0C0); // Beta-Primary-Blue-B4
  // No "Disconnected" pill spec exists yet (only Connected was given) — a
  // neutral gray/red pair for the same shape until a real one is given.
  static const pillDisconnectedBg = Color(0xFFF0EAE3);
  static const pillDisconnected = Color(0xFF9A6B6B);
}

/// The Figma frame is 1600x1800 logical px. Physical Flow Board displays
/// don't all share that exact size, so every raw Figma value must be
/// multiplied by [FlowBoardScale.of] before use — same convention as KDS's
/// KdsScale.
class FlowBoardScale {
  const FlowBoardScale._();

  static const figmaWidth = 1600.0;

  static double of(BuildContext context) => MediaQuery.sizeOf(context).width / figmaWidth;
}
