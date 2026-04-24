import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/model/prism_models.dart';
import 'package:hello_world/prism/renderer/prism_face.dart';
import 'package:hello_world/prism/renderer/prism_renderer.dart';

Map<PrismFaceId, Rect> _faceValues() {
  return {
    for (final faceId in PrismFaceId.values)
      faceId: const Rect.fromLTWH(0, 0, 1, 1),
  };
}

void main() {
  late ui.Image image;

  setUpAll(() async {
    image = await createTestImage(width: 20, height: 20);
  });

  tearDownAll(() {
    image.dispose();
  });

  test('orderedFaces sorts faces from farthest forward depth first', () {
    final renderer = PrismRenderer(
      image: image,
      dimensions: const PrismDimensions(width: 165, depth: 165, height: 178),
      prismFaceValues: _faceValues(),
    );

    final faces = renderer.orderedFaces(Matrix4.identity());

    expect(faces, hasLength(6));
    expect(faces.first.depth, greaterThanOrEqualTo(faces.last.depth));
    expect(faces.map((face) => face.child), everyElement(isA<PrismFace>()));
  });

  testWidgets('orderedFaces uses a labeled fallback for missing crop values', (
    tester,
  ) async {
    final renderer = PrismRenderer(
      image: image,
      dimensions: const PrismDimensions(width: 165, depth: 165, height: 178),
      prismFaceValues: const {PrismFaceId.stem: Rect.fromLTWH(0, 0, 1, 1)},
    );

    final faces = renderer.orderedFaces(Matrix4.identity());

    await tester.pumpWidget(
      MaterialApp(
        home: Stack(children: faces.map((face) => face.child).toList()),
      ),
    );

    expect(find.byType(PrismFace), findsOneWidget);
    expect(find.text('Deck'), findsOneWidget);
    expect(find.text('Keel'), findsOneWidget);
  });
}
