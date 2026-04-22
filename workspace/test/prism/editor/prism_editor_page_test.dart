import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/controls/prism_face_crop_controls.dart';
import 'package:hello_world/prism/editor/prism_editor_page.dart';
import 'package:hello_world/prism/editor/prism_preview_card.dart';

void _setLargeSurface(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(1600, 2000);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('overlay toggle updates the preview card state', (
    WidgetTester tester,
  ) async {
    _setLargeSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: PrismEditorPage()));
    await tester.pump();

    var previewCard = tester.widget<PrismPreviewCard>(find.byType(PrismPreviewCard));
    expect(previewCard.showFaceOverlays, isFalse);

    await tester.tap(find.byKey(const ValueKey('show-face-overlays-switch')));
    await tester.pump();

    previewCard = tester.widget<PrismPreviewCard>(find.byType(PrismPreviewCard));
    expect(previewCard.showFaceOverlays, isTrue);
  });

  testWidgets('face dropdown switches the active crop controls', (
    WidgetTester tester,
  ) async {
    _setLargeSurface(tester);
    await tester.pumpWidget(const MaterialApp(home: PrismEditorPage()));
    await tester.pump();

    var cropControls = tester.widget<PrismFaceCropControls>(
      find.byType(PrismFaceCropControls),
    );
    expect(cropControls.crop.left, closeTo(0.2561, 0.0001));

    await tester.tap(find.byKey(const ValueKey('face-dropdown')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.tap(find.text('Port').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    cropControls = tester.widget<PrismFaceCropControls>(
      find.byType(PrismFaceCropControls),
    );
    expect(cropControls.crop.left, closeTo(0.4796, 0.0001));
    expect(find.textContaining('Left: 0.4796'), findsOneWidget);
  });
}
