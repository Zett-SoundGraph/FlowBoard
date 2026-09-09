import 'package:flow_board/domain/entities/index.dart';

abstract interface class FlowLogRepository {
  Stream<RawMqttMessage> get messageStream;
  Future<void> connect();
}
