import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/model/prism_models.dart';
import 'package:hello_world/prism/renderer/prism_face.dart';

void main() {
  late ui.Image image;

  setUpAll(() async {
    image = await createTestImage(width: 16, height: 16);
  });

  tearDownAll(() {
    image.dispose();
  });

  testWidgets('PrismFace paints the selected crop into the requested size', (
    tester,
  ) async {
    const spec = PrismFaceSpec(
      faceId: PrismFaceId.stem,
      size: Size(40, 60),
      crop: Rect.fromLTWH(0.25, 0.25, 0.5, 0.5),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: RepaintBoundary(
          child: PrismFace(image: image, spec: spec),
        ),
      ),
    );

    final face = tester.widget<SizedBox>(find.byType(SizedBox));
    expect(face.width, spec.size.width);
    expect(face.height, spec.size.height);
    expect(find.byType(CustomPaint), findsWidgets);
  });
}
