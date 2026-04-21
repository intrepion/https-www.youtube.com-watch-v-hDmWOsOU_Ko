import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:hello_world/main.dart';

void main() {
  testWidgets('Prism editor smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Image'), findsOneWidget);
    expect(find.text('Face'), findsOneWidget);
    expect(find.text('Show Face Overlays'), findsOneWidget);
    expect(find.text('Stem'), findsWidgets);
    expect(find.textContaining('Zoom:'), findsOneWidget);
    expect(find.byType(Slider), findsNWidgets(8));
    expect(find.byType(SwitchListTile), findsOneWidget);
  });
}
