import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hello_world/main.dart';
import 'package:hello_world/prism/editor/prism_editor_page.dart';
import 'test_helpers/prism_widget_test_helpers.dart';

void main() {
  testWidgets('app boots into the prism editor page', (
    WidgetTester tester,
  ) async {
    setPrismTestSurface(tester);
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.byType(PrismEditorPage), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
