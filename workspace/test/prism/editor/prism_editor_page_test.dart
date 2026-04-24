import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/controls/prism_rotation_controls.dart';
import 'package:hello_world/prism/controls/prism_face_crop_controls.dart';
import 'package:hello_world/prism/editor/prism_preview_card.dart';
import 'package:hello_world/prism/renderer/rectangular_prism.dart';
import '../../test_helpers/prism_widget_test_helpers.dart';

void main() {
  testWidgets('overlay toggle updates the preview card state', (
    WidgetTester tester,
  ) async {
    await pumpPrismEditor(tester);

    await tester.tap(find.byKey(const ValueKey('show-image-preview-switch')));
    await tester.pump();

    var previewCard = tester.widget<PrismPreviewCard>(
      find.byType(PrismPreviewCard),
    );
    expect(previewCard.showFaceOverlays, isFalse);

    await tester.tap(find.byKey(const ValueKey('show-face-overlays-switch')));
    await tester.pump();

    previewCard = tester.widget<PrismPreviewCard>(
      find.byType(PrismPreviewCard),
    );
    expect(previewCard.showFaceOverlays, isTrue);
  });

  testWidgets('image preview toggle hides the preview card', (
    WidgetTester tester,
  ) async {
    await pumpPrismEditor(tester);

    expect(find.byType(PrismPreviewCard), findsNothing);
    expect(find.byType(PrismFaceCropControls), findsNothing);

    await tester.tap(find.byKey(const ValueKey('show-image-preview-switch')));
    await tester.pump();

    expect(find.byType(PrismPreviewCard), findsOneWidget);
    expect(find.byType(PrismFaceCropControls), findsOneWidget);
  });

  testWidgets('2D panel is removed until image preview is enabled', (
    WidgetTester tester,
  ) async {
    await pumpPrismEditor(tester);

    expect(find.byType(VerticalDivider), findsNothing);

    await tester.tap(find.byKey(const ValueKey('show-image-preview-switch')));
    await tester.pump();

    expect(find.byType(VerticalDivider), findsOneWidget);
    expect(find.byType(RectangularPrism), findsOneWidget);
    expect(find.byType(PrismPreviewCard), findsOneWidget);
  });

  testWidgets('dragging the prism viewport rotates the prism', (
    WidgetTester tester,
  ) async {
    await pumpPrismEditor(tester);

    final initialPrism = tester.widget<RectangularPrism>(
      find.byType(RectangularPrism),
    );

    await tester.drag(find.byType(RectangularPrism), const Offset(0, 100));
    await tester.pump();

    final updatedPrism = tester.widget<RectangularPrism>(
      find.byType(RectangularPrism),
    );
    expect(updatedPrism.rx, isNot(initialPrism.rx));
  });

  testWidgets('transform controls toggle hides rotation sliders', (
    WidgetTester tester,
  ) async {
    await pumpPrismEditor(tester);

    expect(find.byType(PrismRotationControls), findsNothing);

    await tester.tap(
      find.byKey(const ValueKey('show-transform-controls-switch')),
    );
    await tester.pump();

    expect(find.byType(PrismRotationControls), findsOneWidget);
    expect(find.byType(PrismPreviewCard), findsNothing);
  });

  testWidgets('face dropdown switches the active crop controls', (
    WidgetTester tester,
  ) async {
    await pumpPrismEditor(tester);

    await tester.tap(find.byKey(const ValueKey('show-image-preview-switch')));
    await tester.pump();

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
