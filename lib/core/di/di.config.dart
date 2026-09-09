// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../data/repositories/flow_log_repository_impl.dart' as _i330;
import '../../data/sources/remote/mqtt_data_source.dart' as _i126;
import '../../domain/repositories/flow_log_repository.dart' as _i510;
import '../../domain/usecases/connect_usecase.dart' as _i690;
import '../../domain/usecases/index.dart' as _i447;
import '../../domain/usecases/observe_messages_usecase.dart' as _i1003;
import '../../presentation/cubit/flow_board_cubit.dart' as _i141;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  gh.singleton<_i126.IMqttDataSource>(() => _i126.MqttDataSource());
  gh.singleton<_i510.FlowLogRepository>(
    () => _i330.FlowLogRepositoryImpl(gh<_i126.IMqttDataSource>()),
  );
  gh.factory<_i690.ConnectUsecase>(
    () => _i690.ConnectUsecase(gh<_i510.FlowLogRepository>()),
  );
  gh.factory<_i1003.ObserveMessagesUsecase>(
    () => _i1003.ObserveMessagesUsecase(gh<_i510.FlowLogRepository>()),
  );
  gh.factory<_i141.FlowBoardCubit>(
    () => _i141.FlowBoardCubit(
      gh<_i447.ConnectUsecase>(),
      gh<_i447.ObserveMessagesUsecase>(),
    ),
  );
  return getIt;
}
