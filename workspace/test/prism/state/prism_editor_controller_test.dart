import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/config/prism_image_catalog.dart';
import 'package:hello_world/prism/model/prism_models.dart';
import 'package:hello_world/prism/state/prism_editor_controller.dart';

void main() {
  test('setImage ignores unknown asset paths', () {
    final controller = PrismEditorController();
    final before = controller.selectedImageAssetPath;

    controller.setImage('assets/does-not-exist.png');

    expect(controller.selectedImageAssetPath, before);
  });

  test('selectedImageOption falls back to a configured option', () {
    final controller = PrismEditorController();

    controller
      ..setImage(prismImageOptions.last.assetPath)
      ..setImage('assets/does-not-exist.png');

    expect(controller.selectedImageOption.assetPath, prismImageOptions.last.assetPath);
  });

  test('setFace updates selected face with typed ids', () {
    final controller = PrismEditorController();

    controller.setFace(PrismFaceId.port);

    expect(controller.selectedFace, PrismFaceId.port);
  });
}
