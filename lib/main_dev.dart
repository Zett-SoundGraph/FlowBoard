import 'package:flow_board/core/constants/local_subnet_resolver.dart';
import 'package:flow_board/core/di/index.dart';
import 'package:flow_board/core/env/env.dart';
import 'package:flow_board/presentation/cubit/index.dart';
import 'package:flow_board/presentation/screens/flow_board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  // Must come before setupLocator() — an @Singleton data source's
  // constructor could touch a platform channel (needs
  // ServicesBinding.instance to already exist) during eager DI
  // construction. runApp() would normally set this up on its own, but
  // that's too late here since setupLocator() runs before it.
  WidgetsFlutterBinding.ensureInitialized();
  // Not awaited — NetworkConstants.mqttBrokerHost falls back to the
  // currently-deployed site's subnet until this resolves, so nothing needs
  // to block on it (ConnectUsecase already retries on its own and picks up
  // the corrected value automatically).
  LocalSubnetResolver.resolve();
  setupLocator(Env.dev());
  runApp(const FlowBoardApp());
}

class FlowBoardApp extends StatelessWidget {
  const FlowBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow Board',
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => getIt<FlowBoardCubit>(),
        child: const FlowBoardScreen(),
      ),
    );
  }
}
