import 'package:flow_board/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// One row of the log dump (figmaImage/FlowBoard.png) — a timestamp column,
/// an icon+title line, and the raw message body underneath, divided from
/// the next entry by a thin hairline.
class FlowLogEntry extends StatelessWidget {
  final DateTime receivedAt;
  final String iconAsset;
  final String title;
  final String body;
  final double scale;
  final bool isHeartbeat;

  const FlowLogEntry({
    super.key,
    required this.receivedAt,
    required this.iconAsset,
    required this.title,
    required this.body,
    required this.scale,
    this.isHeartbeat = false,
  });

  String get _timestampText {
    final h = receivedAt.hour.toString().padLeft(2, '0');
    final m = receivedAt.minute.toString().padLeft(2, '0');
    final s = receivedAt.second.toString().padLeft(2, '0');
    final ms = receivedAt.millisecond.toString().padLeft(3, '0');
    return '$h:$m:$s:$ms.';
  }

  static const _verticalPadding = 24.0;
  static const _horizontalPadding = 48.0;
  static const _dividerWidth = 1.0;
  static const _timestampColumnWidth = 220.0;
  static const _iconSize = 32.0;
  static const _iconTitleGap = 16.0;
  static const _titleBodyGap = 16.0;
  static const _bodyMaxLines = 4;

  /// The exact height this widget will render at for [title]/[body], at the
  /// log area's actual [maxWidth] — kept alongside the constants it mirrors
  /// (rather than duplicated in the screen that calls it) so the two can
  /// never silently drift apart. Used to decide how many of the most recent
  /// entries fully fit the available height, rather than letting a
  /// scrollable list clip the topmost one mid-entry.
  static double estimateHeight({
    required String title,
    required String body,
    required double scale,
    required double maxWidth,
  }) {
    final contentWidth = maxWidth - _horizontalPadding * 2 * scale;
    final rightColumnWidth =
        (contentWidth - _timestampColumnWidth * scale).clamp(0.0, double.infinity);
    final titleWidth =
        (rightColumnWidth - _iconSize * scale - _iconTitleGap * scale).clamp(0.0, double.infinity);

    final titlePainter = TextPainter(
      text: TextSpan(
        text: title,
        style: TextStyle(
          fontFamily: flowBoardFontFamily,
          fontWeight: FontWeight.w700,
          fontSize: 30 * scale,
        ),
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: titleWidth == 0 ? double.infinity : titleWidth);

    final bodyPainter = TextPainter(
      text: TextSpan(
        text: body,
        style: TextStyle(
          fontFamily: flowBoardFontFamily,
          fontSize: 24 * scale,
          height: 1.4,
        ),
      ),
      maxLines: _bodyMaxLines,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: rightColumnWidth == 0 ? double.infinity : rightColumnWidth);

    final titleRowHeight =
        titlePainter.height > _iconSize * scale ? titlePainter.height : _iconSize * scale;

    return _verticalPadding * 2 * scale +
        titleRowHeight +
        _titleBodyGap * scale +
        bodyPainter.height +
        _dividerWidth * scale;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24 * scale, horizontal: 48 * scale),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: FlowBoardColors.divider, width: 1 * scale),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 220 * scale,
            child: Text(
              _timestampText,
              style: TextStyle(
                fontFamily: flowBoardFontFamily,
                fontWeight: FontWeight.w400,
                fontSize: 24 * scale,
                color: FlowBoardColors.timestamp,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      iconAsset,
                      width: 32 * scale,
                      height: 32 * scale,
                      color: Colors.white,
                    ),
                    SizedBox(width: 16 * scale),
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: flowBoardFontFamily,
                        fontWeight: FontWeight.w700,
                        fontSize: 30 * scale,
                        color: isHeartbeat ? FlowBoardColors.heartbeatText : Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16 * scale),
                Text(
                  body,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: flowBoardFontFamily,
                    fontWeight: FontWeight.w400,
                    fontSize: 24 * scale,
                    height: 1.4,
                    color: isHeartbeat ? FlowBoardColors.heartbeatText : FlowBoardColors.bodyText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
