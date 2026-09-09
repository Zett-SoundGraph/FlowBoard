import 'package:injectable/injectable.dart';

import 'package:flow_board/domain/repositories/flow_log_repository.dart';

@injectable
class ConnectUsecase {
  const ConnectUsecase(this._repository);

  final FlowLogRepository _repository;

  Future<void> call() => _repository.connect();
}
