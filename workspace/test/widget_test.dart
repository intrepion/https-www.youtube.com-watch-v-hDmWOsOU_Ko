import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hello_world/main.dart' as app;
import 'package:hello_world/prism/editor/prism_editor_page.dart';
import 'test_helpers/prism_widget_test_helpers.dart';

void main() {
  testWidgets('app boots into the prism editor page', (
    WidgetTester tester,
  ) async {
    setPrismTestSurface(tester);
    await tester.pumpWidget(const app.MyApp());
    await tester.pump();

    expect(find.byType(PrismEditorPage), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('main launches the app', (WidgetTester tester) async {
    setPrismTestSurface(tester);

    app.main();
    await tester.pump();

    expect(find.byType(PrismEditorPage), findsOneWidget);
  });
}
