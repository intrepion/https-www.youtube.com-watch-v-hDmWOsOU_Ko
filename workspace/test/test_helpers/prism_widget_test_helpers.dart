import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/editor/prism_editor_page.dart';

void setPrismTestSurface(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(1600, 2000);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> pumpPrismEditor(WidgetTester tester) async {
  setPrismTestSurface(tester);
  await tester.pumpWidget(const MaterialApp(home: PrismEditorPage()));
  await tester.pump();
}

Future<void> openDropdownAndChoose(
  WidgetTester tester, {
  required Key dropdownKey,
  required String optionText,
}) async {
  await tester.tap(find.byKey(dropdownKey));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
  await tester.tap(find.text(optionText).last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 250));
}
