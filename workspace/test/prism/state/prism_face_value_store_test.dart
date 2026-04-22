import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/model/prism_models.dart';
import 'package:hello_world/prism/state/prism_face_value_store.dart';

void main() {
  const dimensions = PrismDimensions(width: 165, depth: 165, height: 178);

  test('faceValuesFor returns a read-only map view', () {
    final store = PrismFaceValueStore();
    final values = store.faceValuesFor(dimensions);

    expect(
      () => values[PrismFaceId.stem] = const Rect.fromLTWH(0, 0, 1, 1),
      throwsUnsupportedError,
    );
  });

  test(
    'updateSelectedCrop clamps crop within bounds and increments version',
    () {
      final store = PrismFaceValueStore();

      final changed = store.updateSelectedCrop(
        dimensions: dimensions,
        selectedFace: PrismFaceId.stem,
        left: 0.95,
        top: 0.98,
        width: 0.4,
        height: 0.4,
      );

      expect(changed, isTrue);
      expect(store.version, 1);

      final crop = store.selectedCrop(
        dimensions: dimensions,
        selectedFace: PrismFaceId.stem,
      );

      expect(crop.left, closeTo(0.95, 0.000001));
      expect(crop.top, closeTo(0.98, 0.000001));
      expect(crop.width, closeTo(0.05, 0.000001));
      expect(crop.height, closeTo(0.05, 0.000001));
    },
  );

  test('updateSelectedCrop does not increment version when unchanged', () {
    final store = PrismFaceValueStore();

    final changed = store.updateSelectedCrop(
      dimensions: dimensions,
      selectedFace: PrismFaceId.stem,
    );

    expect(changed, isFalse);
    expect(store.version, 0);
  });
}
