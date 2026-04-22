import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/controls/prism_face_crop_controls.dart';
import 'package:hello_world/prism/editor/prism_preview_card.dart';
import '../../test_helpers/prism_widget_test_helpers.dart';

void main() {
  testWidgets('overlay toggle updates the preview card state', (
    WidgetTester tester,
  ) async {
    await pumpPrismEditor(tester);

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
    await pumpPrismEditor(tester);

    var cropControls = tester.widget<PrismFaceCropControls>(
      find.byType(PrismFaceCropControls),
    );
    expect(cropControls.crop.left, closeTo(0.2561, 0.0001));

    await openDropdownAndChoose(
      tester,
      dropdownKey: const ValueKey('face-dropdown'),
      optionText: 'Port',
    );

    cropControls = tester.widget<PrismFaceCropControls>(
      find.byType(PrismFaceCropControls),
    );
    expect(cropControls.crop.left, closeTo(0.4796, 0.0001));
    expect(find.textContaining('Left: 0.4796'), findsOneWidget);
  });
}
