import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flow_board/domain/entities/index.dart';

part 'flow_board_state.freezed.dart';

@freezed
abstract class FlowBoardState with _$FlowBoardState {
  const factory FlowBoardState({
    required DateTime appStartedAt,
    @Default(<RawMqttMessage>[]) List<RawMqttMessage> entries,
    @Default(0) int totalMessagesReceived,
    @Default(<String, DateTime>{}) Map<String, DateTime> deviceLastSeen,
    // Every FleetDevice.leaderStateField value that's actually meaningful in
    // beta/flowhub/leader/update's payload (isPrinterConnected/
    // isCayeConnected) — a malformed/unrelated message on that topic just
    // leaves whatever was last known untouched.
    @Default(<String, bool>{}) Map<String, bool> leaderState,
    // Bumped every second by a Cubit-owned timer purely to force a rebuild
    // for the uptime clock — uptime itself is derived fresh at render time
    // from [appStartedAt], never stored here.
    @Default(0) int clockTick,
  }) = _FlowBoardState;
}
