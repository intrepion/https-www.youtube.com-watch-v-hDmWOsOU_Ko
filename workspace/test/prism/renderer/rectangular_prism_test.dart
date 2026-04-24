import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/config/prism_face_presets.dart';
import 'package:hello_world/prism/model/prism_models.dart';
import 'package:hello_world/prism/renderer/prism_face.dart';
import 'package:hello_world/prism/renderer/rectangular_prism.dart';

void main() {
  late ui.Image image;

  setUpAll(() async {
    image = await createTestImage(width: 20, height: 20);
  });

  tearDownAll(() {
    image.dispose();
  });

  testWidgets('ResolvedRectangularPrism renders transformed faces', (
    tester,
  ) async {
    const dimensions = PrismDimensions(width: 165, depth: 165, height: 178);

    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: ResolvedRectangularPrism(
            image: image,
            dimensions: dimensions,
            rx: 0.1,
            ry: 0.2,
            rz: 0.3,
            zoom: 1.2,
            prismFaceValues: defaultPrismFaceValuesByDimensions[dimensions]!,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byType(Transform), findsWidgets);
    expect(find.byType(Stack), findsOneWidget);
    expect(find.byType(PrismFace), findsNWidgets(6));
  });
}
