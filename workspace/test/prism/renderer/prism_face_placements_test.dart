import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/model/prism_models.dart';
import 'package:hello_world/prism/renderer/prism_face_placements.dart';

void main() {
  test('buildPrismFacePlacements returns each face with expected centers', () {
    const dimensions = PrismDimensions(width: 165, depth: 165, height: 270);

    final placements = buildPrismFacePlacements(dimensions);

    expect(placements.map((placement) => placement.faceId), [
      PrismFaceId.stern,
      PrismFaceId.keel,
      PrismFaceId.starboard,
      PrismFaceId.port,
      PrismFaceId.deck,
      PrismFaceId.stem,
    ]);
    expect(placements[0].center.z, 82.5);
    expect(placements[1].center.y, 135);
    expect(placements[2].center.x, -82.5);
    expect(placements[3].center.x, 82.5);
    expect(placements[4].center.y, -135);
    expect(placements[5].center.z, -82.5);
  });

  test('face transforms place opposite faces on opposite sides', () {
    const dimensions = PrismDimensions(width: 165, depth: 165, height: 270);

    final placements = buildPrismFacePlacements(dimensions);
    final sternTransform = placements
        .singleWhere((placement) => placement.faceId == PrismFaceId.stern)
        .transform;
    final stemTransform = placements
        .singleWhere((placement) => placement.faceId == PrismFaceId.stem)
        .transform;

    expect(sternTransform.getTranslation().z, 82.5);
    expect(stemTransform.getTranslation().z, -82.5);
    expect(sternTransform.storage[0], closeTo(cos(pi), 0.0001));
    expect(stemTransform.storage[0], closeTo(1, 0.0001));
  });
}
