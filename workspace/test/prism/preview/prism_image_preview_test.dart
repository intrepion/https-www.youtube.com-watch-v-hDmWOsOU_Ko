import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/config/prism_face_presets.dart';
import 'package:hello_world/prism/config/prism_image_catalog.dart';
import 'package:hello_world/prism/model/prism_models.dart';
import 'package:hello_world/prism/preview/prism_image_preview.dart';

void main() {
  late ui.Image image;

  setUpAll(() async {
    image = await createTestImage(width: 20, height: 10);
  });

  tearDownAll(() {
    image.dispose();
  });

  testWidgets(
    'ResolvedPrismImagePreview shows image with optional face overlays',
    (WidgetTester tester) async {
      final imageOption = prismImageOptions.first;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResolvedPrismImagePreview(
              image: image,
              assetPath: imageOption.assetPath,
              prismFaceValues:
                  defaultPrismFaceValuesByDimensions[imageOption.dimensions]!,
              selectedFace: PrismFaceId.stem,
              showFaceOverlays: true,
              faceValuesVersion: 1,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    },
  );

  testWidgets('shows an error placeholder when the asset cannot load', (
    WidgetTester tester,
  ) async {
    final imageOption = PrismImageOption.fromAssetPath(
      'assets/scentsy-box-165x165x178-missing.png',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PrismImagePreview(
            imageOption: imageOption,
            prismFaceValues: const {
              PrismFaceId.stem: Rect.fromLTWH(0.2, 0.2, 0.2, 0.2),
            },
            selectedFace: PrismFaceId.stem,
            showFaceOverlays: false,
            faceValuesVersion: 0,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Image failed to load'), findsOneWidget);
  });
}
