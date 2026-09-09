import 'package:injectable/injectable.dart';

import 'package:flow_board/core/di/di.config.dart';
import 'package:flow_board/core/di/service_locator.dart';
import 'package:flow_board/core/env/env.dart';

export 'package:flow_board/core/di/service_locator.dart';

@InjectableInit(
  initializerName: r'$initGetIt',
  preferRelativeImports: true,
  asExtension: false,
)
void setupLocator(Env env) {
  getIt.registerSingleton<Env>(env);
  $initGetIt(getIt);
}
