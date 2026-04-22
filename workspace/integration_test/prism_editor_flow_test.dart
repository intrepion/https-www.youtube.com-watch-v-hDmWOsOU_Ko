import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:hello_world/main.dart';
import 'package:hello_world/prism/controls/prism_face_crop_controls.dart';
import 'package:hello_world/prism/editor/prism_preview_card.dart';

void _setLargeSurface(WidgetTester tester) {
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(1600, 2000);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> _openDropdownAndChoose(
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

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('editor flow updates image, overlays, and selected face', (
    WidgetTester tester,
  ) async {
    _setLargeSurface(tester);
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    var previewCard = tester.widget<PrismPreviewCard>(
      find.byType(PrismPreviewCard),
    );
    expect(previewCard.imageOption.name, 'ewok');
    expect(previewCard.showFaceOverlays, isFalse);

    await _openDropdownAndChoose(
      tester,
      dropdownKey: const ValueKey('image-dropdown'),
      optionText: 'Elsa (165x165x178)',
    );

    previewCard = tester.widget<PrismPreviewCard>(
      find.byType(PrismPreviewCard),
    );
    expect(previewCard.imageOption.name, 'elsa');

    await tester.tap(find.byKey(const ValueKey('show-face-overlays-switch')));
    await tester.pump();

    previewCard = tester.widget<PrismPreviewCard>(
      find.byType(PrismPreviewCard),
    );
    expect(previewCard.showFaceOverlays, isTrue);

    var cropControls = tester.widget<PrismFaceCropControls>(
      find.byType(PrismFaceCropControls),
    );
    expect(cropControls.crop.left, closeTo(0.2561, 0.0001));

    await _openDropdownAndChoose(
      tester,
      dropdownKey: const ValueKey('face-dropdown'),
      optionText: 'Port',
    );

    cropControls = tester.widget<PrismFaceCropControls>(
      find.byType(PrismFaceCropControls),
    );
    expect(cropControls.crop.left, closeTo(0.4796, 0.0001));
  });
}
