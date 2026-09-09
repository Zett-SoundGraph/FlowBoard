import 'package:injectable/injectable.dart';

import 'package:flow_board/data/sources/remote/mqtt_data_source.dart';
import 'package:flow_board/domain/entities/index.dart';
import 'package:flow_board/domain/repositories/flow_log_repository.dart';

@Singleton(as: FlowLogRepository)
class FlowLogRepositoryImpl implements FlowLogRepository {
  const FlowLogRepositoryImpl(this._dataSource);

  final IMqttDataSource _dataSource;

  @override
  Stream<RawMqttMessage> get messageStream => _dataSource.messageStream;

  @override
  Future<void> connect() => _dataSource.connect();
}
