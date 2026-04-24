import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/model/prism_models.dart';
import 'package:hello_world/prism/preview/prism_face_overlay_painter.dart';

void main() {
  test('paint draws face rectangles and labels without throwing', () {
    const values = {
      PrismFaceId.stem: Rect.fromLTWH(0.1, 0.1, 0.2, 0.2),
      PrismFaceId.deck: Rect.fromLTWH(0.4, 0.1, 0.2, 0.2),
    };
    const painter = PrismFaceOverlayPainter(
      prismFaceValues: values,
      selectedFace: PrismFaceId.stem,
      faceValuesVersion: 1,
    );
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    painter.paint(canvas, const Size(200, 200));
    final picture = recorder.endRecording();

    expect(picture, isA<ui.Picture>());
    picture.dispose();
  });

  test('shouldRepaint tracks selected face, version, and map identity', () {
    const values = {PrismFaceId.stem: Rect.fromLTWH(0.1, 0.1, 0.2, 0.2)};
    const painter = PrismFaceOverlayPainter(
      prismFaceValues: values,
      selectedFace: PrismFaceId.stem,
      faceValuesVersion: 1,
    );

    expect(
      painter.shouldRepaint(
        const PrismFaceOverlayPainter(
          prismFaceValues: values,
          selectedFace: PrismFaceId.port,
          faceValuesVersion: 1,
        ),
      ),
      isTrue,
    );
    expect(
      painter.shouldRepaint(
        const PrismFaceOverlayPainter(
          prismFaceValues: values,
          selectedFace: PrismFaceId.stem,
          faceValuesVersion: 0,
        ),
      ),
      isTrue,
    );
    expect(
      painter.shouldRepaint(
        PrismFaceOverlayPainter(
          prismFaceValues: Map.of(values),
          selectedFace: PrismFaceId.stem,
          faceValuesVersion: 1,
        ),
      ),
      isTrue,
    );
    expect(
      painter.shouldRepaint(
        const PrismFaceOverlayPainter(
          prismFaceValues: values,
          selectedFace: PrismFaceId.stem,
          faceValuesVersion: 1,
        ),
      ),
      isFalse,
    );
  });
}
