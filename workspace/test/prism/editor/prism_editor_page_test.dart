import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/config/prism_face_presets.dart';
import 'package:hello_world/prism/config/prism_image_catalog.dart';
import 'package:hello_world/prism/controls/prism_rotation_controls.dart';
import 'package:hello_world/prism/controls/prism_face_crop_controls.dart';
import 'package:hello_world/prism/editor/prism_editor_layout.dart';
import 'package:hello_world/prism/editor/prism_face_editor_section.dart';
import 'package:hello_world/prism/editor/prism_image_panel.dart';
import 'package:hello_world/prism/editor/prism_image_selector.dart';
import 'package:hello_world/prism/editor/prism_preview_card.dart';
import 'package:hello_world/prism/model/prism_models.dart';
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

  testWidgets('editor layout stacks panels on narrow screens', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(800, 600);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: PrismEditorLayout(
          prismPanel: Text('Prism panel'),
          imagePanel: Text('Image panel'),
        ),
      ),
    );

    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Row), findsNothing);
    expect(find.text('Prism panel'), findsOneWidget);
    expect(find.text('Image panel'), findsOneWidget);
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

  testWidgets('pinching the prism viewport updates zoom', (
    WidgetTester tester,
  ) async {
    await pumpPrismEditor(tester);

    final initialPrism = tester.widget<RectangularPrism>(
      find.byType(RectangularPrism),
    );
    final center = tester.getCenter(find.byType(RectangularPrism));
    final firstFinger = await tester.startGesture(
      center.translate(-20, 0),
      pointer: 1,
    );
    final secondFinger = await tester.startGesture(
      center.translate(20, 0),
      pointer: 2,
    );

    await firstFinger.moveTo(center.translate(-80, 0));
    await secondFinger.moveTo(center.translate(80, 0));
    await tester.pump();
    await firstFinger.up();
    await secondFinger.up();
    await tester.pump();

    final updatedPrism = tester.widget<RectangularPrism>(
      find.byType(RectangularPrism),
    );
    expect(updatedPrism.zoom, greaterThan(initialPrism.zoom));
  });

  testWidgets('dragging still rotates the prism after pinching', (
    WidgetTester tester,
  ) async {
    await pumpPrismEditor(tester);

    final center = tester.getCenter(find.byType(RectangularPrism));
    final firstFinger = await tester.startGesture(
      center.translate(-20, 0),
      pointer: 1,
    );
    final secondFinger = await tester.startGesture(
      center.translate(20, 0),
      pointer: 2,
    );

    await firstFinger.moveTo(center.translate(-80, 0));
    await secondFinger.moveTo(center.translate(80, 0));
    await tester.pump();
    await firstFinger.up();
    await secondFinger.up();
    await tester.pump();

    final zoomedPrism = tester.widget<RectangularPrism>(
      find.byType(RectangularPrism),
    );

    await tester.drag(find.byType(RectangularPrism), const Offset(0, 100));
    await tester.pump();

    final rotatedPrism = tester.widget<RectangularPrism>(
      find.byType(RectangularPrism),
    );
    expect(rotatedPrism.rx, isNot(zoomedPrism.rx));
  });

  testWidgets('pointer scale signals zoom the prism on trackpads', (
    WidgetTester tester,
  ) async {
    await pumpPrismEditor(tester);

    final initialPrism = tester.widget<RectangularPrism>(
      find.byType(RectangularPrism),
    );
    final center = tester.getCenter(find.byType(RectangularPrism));

    tester.binding.handlePointerEvent(
      PointerScrollEvent(position: center, scrollDelta: const Offset(0, 20)),
    );
    await tester.pump();
    expect(
      tester.widget<RectangularPrism>(find.byType(RectangularPrism)).zoom,
      initialPrism.zoom,
    );

    tester.binding.handlePointerEvent(
      PointerScaleEvent(position: center, scale: 1.5),
    );
    await tester.pump();

    final zoomedPrism = tester.widget<RectangularPrism>(
      find.byType(RectangularPrism),
    );
    expect(zoomedPrism.zoom, greaterThan(initialPrism.zoom));
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

  testWidgets('face crop sliders update all crop dimensions', (
    WidgetTester tester,
  ) async {
    await pumpPrismEditor(tester);

    await tester.tap(find.byKey(const ValueKey('show-image-preview-switch')));
    await tester.pump();

    final sliders = tester.widgetList<Slider>(find.byType(Slider)).toList();
    sliders[0].onChanged?.call(0.1);
    sliders[1].onChanged?.call(0.2);
    sliders[2].onChanged?.call(0.3);
    sliders[3].onChanged?.call(0.4);
    await tester.pump();

    final cropControls = tester.widget<PrismFaceCropControls>(
      find.byType(PrismFaceCropControls),
    );
    expect(cropControls.crop.left, closeTo(0.1, 0.0001));
    expect(cropControls.crop.top, closeTo(0.2, 0.0001));
    expect(cropControls.crop.width, closeTo(0.3, 0.0001));
    expect(cropControls.crop.height, closeTo(0.4, 0.0001));
  });

  testWidgets('image selector ignores null changes and emits selected images', (
    WidgetTester tester,
  ) async {
    final selectedImages = <PrismImageOption>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrismImageSelector(
            selectedImageOption: prismImageOptions.first,
            imageOptions: prismImageOptions,
            onImageChanged: selectedImages.add,
          ),
        ),
      ),
    );

    final dropdown = tester.widget<DropdownButton<PrismImageOption>>(
      find.byKey(const ValueKey('image-dropdown')),
    );
    dropdown.onChanged?.call(null);
    dropdown.onChanged?.call(prismImageOptions.last);

    expect(selectedImages, [prismImageOptions.last]);
  });

  testWidgets('face editor ignores null face selections', (
    WidgetTester tester,
  ) async {
    final selectedFaces = <PrismFaceId>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrismFaceEditorSection(
            selectedFace: PrismFaceId.stem,
            showFaceOverlays: false,
            onFaceChanged: selectedFaces.add,
            onShowFaceOverlaysChanged: (_) {},
            controls: const SizedBox.shrink(),
          ),
        ),
      ),
    );

    final dropdown = tester.widget<DropdownButton<PrismFaceId>>(
      find.byKey(const ValueKey('face-dropdown')),
    );
    dropdown.onChanged?.call(null);
    dropdown.onChanged?.call(PrismFaceId.port);

    expect(selectedFaces, [PrismFaceId.port]);
  });

  testWidgets('image panel can render as hidden placeholder', (
    WidgetTester tester,
  ) async {
    final imageOption = prismImageOptions.first;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrismImagePanel(
            selectedImageOption: imageOption,
            prismFaceValues:
                defaultPrismFaceValuesByDimensions[imageOption.dimensions]!,
            selectedFace: PrismFaceId.stem,
            showFaceOverlays: false,
            showImagePreview: false,
            faceValuesVersion: 0,
            onFaceChanged: (_) {},
            onShowFaceOverlaysChanged: (_) {},
            faceControls: PrismFaceCropControls(
              crop: const Rect.fromLTWH(0.1, 0.2, 0.3, 0.4),
              onLeftChanged: (_) {},
              onTopChanged: (_) {},
              onWidthChanged: (_) {},
              onHeightChanged: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(PrismPreviewCard), findsNothing);
    expect(find.byType(SizedBox), findsOneWidget);
  });
}
