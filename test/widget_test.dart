import 'package:flutter_test/flutter_test.dart';

import 'package:flow_board/core/di/index.dart';
import 'package:flow_board/core/env/env.dart';
import 'package:flow_board/main_dev.dart';

void main() {
  testWidgets('FlowBoardApp builds without throwing', (WidgetTester tester) async {
    setupLocator(Env.dev());
    await tester.pumpWidget(const FlowBoardApp());
    await tester.pump();
  });
}
