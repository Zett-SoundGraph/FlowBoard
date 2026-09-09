import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flow_board/core/theme/app_theme.dart';
import 'package:flow_board/domain/entities/index.dart';
import 'package:flow_board/presentation/cubit/index.dart';
import 'package:flow_board/presentation/widgets/flow_board_header.dart';
import 'package:flow_board/presentation/widgets/flow_log_entry.dart';

/// figmaImage/FlowBoard.png, 1600x1800: the header (uptime/connected-clients/
/// Messages stats + Device Fleet grid) on top, the MQTT log dump below.
class FlowBoardScreen extends StatelessWidget {
  const FlowBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = FlowBoardScale.of(context);
    final cubit = context.watch<FlowBoardCubit>();
    final state = cubit.state;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          FlowBoardHeader(
            scale: scale,
            uptime: DateTime.now().difference(state.appStartedAt),
            connectedCount: kFleetDevices.where(cubit.isDeviceConnected).length,
            totalMessages: state.totalMessagesReceived,
            isConnected: cubit.isDeviceConnected,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: FlowBoardColors.logBg,
              child: state.entries.isEmpty
                  ? Center(
                      child: Text(
                        'Waiting for MQTT messages…',
                        style: TextStyle(
                          fontFamily: flowBoardFontFamily,
                          fontSize: 28 * scale,
                          color: FlowBoardColors.bodyText,
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        const verticalPadding = 16.0;
                        var usedHeight = verticalPadding * 2 * scale;
                        // entries[0] is the newest — walk newest-to-oldest,
                        // keeping only however many fully fit the available
                        // height. The first one that WOULDN'T fully fit gets
                        // dropped entirely rather than clipped mid-entry, so
                        // the topmost visible entry is always whole.
                        final fitting = <RawMqttMessage>[];
                        for (final entry in state.entries) {
                          final source = resolveMqttTopicSource(entry.topic);
                          final height = FlowLogEntry.estimateHeight(
                            title: source.title,
                            body: entry.payload,
                            scale: scale,
                            maxWidth: constraints.maxWidth,
                          );
                          if (usedHeight + height > constraints.maxHeight) break;
                          usedHeight += height;
                          fitting.add(entry);
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: verticalPadding * scale),
                          child: Column(
                            // Top-anchored rather than bottom-anchored: the
                            // topmost entry's top edge always sits flush with
                            // the boundary (never cut, never gapped above
                            // it). Any leftover slack shows below the newest
                            // entry instead — reads as "room for what's
                            // coming next" rather than dead space sitting
                            // above old content.
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // fitting is newest-first; reverse so the oldest
                              // of the fitting set renders at the top.
                              for (final entry in fitting.reversed)
                                Builder(builder: (context) {
                                  final source = resolveMqttTopicSource(entry.topic);
                                  return FlowLogEntry(
                                    receivedAt: entry.receivedAt,
                                    iconAsset: source.icon,
                                    title: source.title,
                                    body: entry.payload,
                                    scale: scale,
                                    isHeartbeat: entry.topic.startsWith(heartbeatTopicPrefix),
                                  );
                                }),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
