import 'package:flutter_test/flutter_test.dart';
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
}
