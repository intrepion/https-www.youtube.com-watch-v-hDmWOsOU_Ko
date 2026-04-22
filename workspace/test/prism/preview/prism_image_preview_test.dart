import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/model/prism_models.dart';
import 'package:hello_world/prism/preview/prism_image_preview.dart';

void main() {
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
