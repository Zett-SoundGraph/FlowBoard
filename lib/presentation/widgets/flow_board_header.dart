import 'package:flow_board/core/theme/app_theme.dart';
import 'package:flow_board/domain/entities/index.dart';
import 'package:flutter/material.dart';

String formatCount(int n) {
  final digits = n.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return buffer.toString();
}

/// The not-yet-built top section of figmaImage/FlowBoard.png: uptime /
/// connected-clients / Messages stat row, then the Device Fleet grid.
/// Sizes/colors below are sampled directly from that image (1600x1800
/// frame) — approximate, per a first-pass build; expect follow-up tweaks.
class FlowBoardHeader extends StatelessWidget {
  final double scale;
  final Duration uptime;
  final int connectedCount;
  final int totalMessages;
  final bool Function(FleetDevice device) isConnected;

  const FlowBoardHeader({
    super.key,
    required this.scale,
    required this.uptime,
    required this.connectedCount,
    required this.totalMessages,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: FlowBoardColors.headerBg,
      padding: EdgeInsets.fromLTRB(56 * scale, 40 * scale, 56 * scale, 32 * scale),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StatCard(
                scale: scale,
                label: 'uptime',
                value: _UptimeValue(scale: scale, uptime: uptime),
              ),
              SizedBox(width: 24 * scale),
              _StatCard(
                scale: scale,
                label: 'connected clients',
                value: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$connectedCount',
                      style: _valueStyle(
                        scale,
                        FlowBoardColors.cardValueBlueB5,
                        letterSpacingPercent: 0.04,
                      ),
                    ),
                    SizedBox(width: 16 * scale),
                    Text(
                      '/',
                      style: _valueStyle(
                        scale,
                        FlowBoardColors.cardValueMuted,
                        letterSpacingPercent: 0.04,
                      ),
                    ),
                    SizedBox(width: 16 * scale),
                    Text(
                      '${kFleetDevices.length}',
                      style: _valueStyle(
                        scale,
                        FlowBoardColors.cardValueMuted,
                        letterSpacingPercent: 0.04,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 24 * scale),
              _StatCard(
                scale: scale,
                label: 'Messages',
                value: Text(
                  formatCount(totalMessages),
                  style: _valueStyle(
                    scale,
                    FlowBoardColors.cardValueNavy,
                    letterSpacingPercent: 0.04,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40 * scale),
          Text(
            'Device Fleet',
            style: TextStyle(
              fontFamily: flowBoardFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 24 * scale,
              height: 32 / 24,
              letterSpacing: 0,
              color: FlowBoardColors.cardLabel,
            ),
          ),
          SizedBox(height: 16 * scale),
          for (var row = 0; row < 2; row++) ...[
            if (row > 0) SizedBox(height: 16 * scale),
            Row(
              children: [
                for (var col = 0; col < 6; col++) ...[
                  if (col > 0) SizedBox(width: 24 * scale),
                  Expanded(
                    child: Builder(builder: (context) {
                      final device = kFleetDevices[row * 6 + col];
                      return _DeviceFleetCard(
                        scale: scale,
                        device: device,
                        connected: isConnected(device),
                      );
                    }),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// letter-spacing in the Figma spec is given as a percentage of font-size
// (Figma's own convention), so it's converted to Flutter's px value here
// rather than at each call site.
TextStyle _valueStyle(
  double scale,
  Color color, {
  required double letterSpacingPercent,
}) =>
    TextStyle(
      fontFamily: flowBoardFontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 48 * scale,
      height: 1.34,
      letterSpacing: 48 * scale * letterSpacingPercent,
      color: color,
    );

/// uptime's two-part value ("2d" then "HH:MM:SS") — separate [Text]s (not
/// one string) since each half has its own letter-spacing, and the time
/// half additionally uses tabular-width digits ("full widths" in the spec)
/// "full widths" in the spec means literal fullwidth (전각/全角) Unicode
/// digit/colon glyphs, not a tabular-figures font feature — each fullwidth
/// glyph draws inside a full 1em square, which is what the paired -30%
/// letter-spacing is calibrated to compensate for (pulling the extra side
/// bearing back in). Applying that same -30% spacing to ordinary halfwidth
/// digits instead just crushes them into each other with no built-in
/// bearing to absorb it — which is exactly the overlap this replaces.
String _toFullWidth(String input) {
  final buffer = StringBuffer();
  for (final rune in input.runes) {
    // Halfwidth '!'–'~' (0x21–0x7E) → Fullwidth Forms block, a fixed
    // +0xFEE0 offset (0x30 '0' → 0xFF10 fullwidth '0', 0x3A ':' → 0xFF1A
    // fullwidth ':', etc.).
    buffer.writeCharCode(rune >= 0x21 && rune <= 0x7E ? rune + 0xFEE0 : rune);
  }
  return buffer.toString();
}

class _UptimeValue extends StatelessWidget {
  final double scale;
  final Duration uptime;

  const _UptimeValue({required this.scale, required this.uptime});

  @override
  Widget build(BuildContext context) {
    final days = uptime.inDays;
    final hours = (uptime.inHours % 24).toString().padLeft(2, '0');
    final minutes = (uptime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (uptime.inSeconds % 60).toString().padLeft(2, '0');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${days}d',
          style: _valueStyle(scale, FlowBoardColors.cardValueDark, letterSpacingPercent: 0.12),
        ),
        SizedBox(width: 16 * scale),
        Text(
          _toFullWidth('$hours:$minutes:$seconds'),
          style: _valueStyle(scale, FlowBoardColors.cardValueDark, letterSpacingPercent: -0.30),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final double scale;
  final String label;
  final Widget value;

  const _StatCard({
    required this.scale,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: flowBoardFontFamily,
              fontWeight: FontWeight.w700,
              fontSize: 24 * scale,
              height: 32 / 24,
              letterSpacing: 0,
              color: FlowBoardColors.cardLabel,
            ),
          ),
          SizedBox(height: 16 * scale),
          Container(
            height: 112 * scale,
            width: double.infinity,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(
              top: 24 * scale,
              right: 24 * scale,
              bottom: 24 * scale,
            ),
            decoration: BoxDecoration(
              color: FlowBoardColors.cardBg,
              border: Border.all(color: FlowBoardColors.cardBorder, width: 1 * scale),
              borderRadius: BorderRadius.circular(16 * scale),
            ),
            child: value,
          ),
        ],
      ),
    );
  }
}

class _DeviceFleetCard extends StatelessWidget {
  final double scale;
  final FleetDevice device;
  final bool connected;

  const _DeviceFleetCard({
    required this.scale,
    required this.device,
    required this.connected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68 * scale,
      padding: EdgeInsets.only(
        top: 16 * scale,
        right: 16 * scale,
        bottom: 16 * scale,
        left: 32 * scale,
      ),
      decoration: BoxDecoration(
        color: FlowBoardColors.cardBg,
        border: Border.all(color: FlowBoardColors.cardBorder, width: 1 * scale),
        borderRadius: BorderRadius.circular(16 * scale),
      ),
      child: Row(
        children: [
          Image.asset(
            device.icon,
            width: 32 * scale,
            height: 32 * scale,
            color: FlowBoardColors.cardValueDark,
          ),
          // No fixed-width gap here — the spec's "gap: 40" is only the
          // natural leftover once the pill (below) takes exactly what it
          // needs and right-aligns. A rigid 40px reservation left the pill
          // pinned to exactly 108px with zero slack, which was clipping
          // even "Connected" itself (Figma's own metrics vs Flutter's
          // rendered glyph widths don't match to the pixel). Letting the
          // gap flex instead means it shrinks first before any text ever
          // has to.
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.only(
                  top: 4 * scale,
                  right: 8 * scale,
                  bottom: 4 * scale,
                  left: 8 * scale,
                ),
                decoration: BoxDecoration(
                  color: connected ? FlowBoardColors.pillBg : FlowBoardColors.pillDisconnectedBg,
                  borderRadius: BorderRadius.circular(8 * scale),
                ),
                child: Text(
                  connected ? 'Connected' : 'Disconnected',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: flowBoardFontFamily,
                    fontWeight: FontWeight.w700,
                    fontSize: 16 * scale,
                    height: 28 / 16,
                    letterSpacing: 16 * scale * -0.015,
                    color: connected ? FlowBoardColors.pillConnected : FlowBoardColors.pillDisconnected,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
