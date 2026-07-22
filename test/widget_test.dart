import 'package:flutter_test/flutter_test.dart';

import 'package:caf_sdk_flutter_example/main.dart';

void main() {
  testWidgets('renders CAF SDK example home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('CAF SDK Example'), findsOneWidget);
    expect(find.text('Initialize SDK'), findsOneWidget);
    expect(find.text('CAF SDK Configuration'), findsOneWidget);
  });
}
