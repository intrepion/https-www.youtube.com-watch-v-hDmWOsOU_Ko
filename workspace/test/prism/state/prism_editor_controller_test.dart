import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/prism/config/prism_image_catalog.dart';
import 'package:hello_world/prism/model/prism_models.dart';
import 'package:hello_world/prism/state/prism_editor_controller.dart';

void main() {
  test('visibility toggles default to hiding optional panels', () {
    final controller = PrismEditorController();

    expect(controller.snapshot.showImagePreview, isFalse);
    expect(controller.snapshot.showTransformControls, isFalse);
  });

  test('setImage updates the selected option with a typed image value', () {
    final controller = PrismEditorController();

    controller.setImage(prismImageOptions.last);

    expect(controller.snapshot.selectedImageOption, prismImageOptions.last);
  });

  test('snapshot keeps the selected image dimensions and crop in sync', () {
    final controller = PrismEditorController();

    controller
      ..setImage(prismImageOptions.last)
      ..setFace(PrismFaceId.port);

    final snapshot = controller.snapshot;

    expect(snapshot.selectedImageOption, prismImageOptions.last);
    expect(snapshot.dimensions, prismImageOptions.last.dimensions);
    expect(
      snapshot.selectedCrop,
      snapshot.activePrismFaceValues[PrismFaceId.port],
    );
  });

  test('setFace updates selected face with typed ids', () {
    final controller = PrismEditorController();

    controller.setFace(PrismFaceId.port);

    expect(controller.snapshot.selectedFace, PrismFaceId.port);
  });

  test('scaleZoom changes zoom relative to gesture start', () {
    final controller = PrismEditorController();

    controller
      ..setZoom(1.5)
      ..startZoomGesture()
      ..scaleZoom(1.5);

    expect(controller.snapshot.zoom, closeTo(2.25, 0.0001));
  });

  test('unchanged values do not notify listeners', () {
    final controller = PrismEditorController();
    var notifyCount = 0;
    controller.addListener(() => notifyCount += 1);

    controller
      ..setImage(controller.snapshot.selectedImageOption)
      ..setFace(controller.snapshot.selectedFace)
      ..setShowFaceOverlays(controller.snapshot.showFaceOverlays)
      ..setShowImagePreview(controller.snapshot.showImagePreview)
      ..setShowTransformControls(controller.snapshot.showTransformControls)
      ..setRx(controller.snapshot.rx)
      ..setRy(controller.snapshot.ry)
      ..setRz(controller.snapshot.rz)
      ..setZoom(controller.snapshot.zoom)
      ..scaleZoom(1.0)
      ..rotateByDelta(Offset.zero)
      ..updateSelectedCrop();

    expect(notifyCount, 0);
  });

  test('rotation and crop changes notify listeners', () {
    final controller = PrismEditorController();
    var notifyCount = 0;
    controller.addListener(() => notifyCount += 1);

    controller
      ..rotateByDrag(
        DragUpdateDetails(
          globalPosition: Offset.zero,
          delta: const Offset(4, 2),
        ),
      )
      ..rotateByDelta(const Offset(2, 4))
      ..updateSelectedCrop(left: 0.2);

    expect(notifyCount, 3);
  });
}
