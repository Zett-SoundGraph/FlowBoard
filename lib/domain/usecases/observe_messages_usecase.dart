import 'package:injectable/injectable.dart';

import 'package:flow_board/domain/entities/index.dart';
import 'package:flow_board/domain/repositories/flow_log_repository.dart';

@injectable
class ObserveMessagesUsecase {
  const ObserveMessagesUsecase(this._repository);

  final FlowLogRepository _repository;

  Stream<RawMqttMessage> call() => _repository.messageStream;
}
