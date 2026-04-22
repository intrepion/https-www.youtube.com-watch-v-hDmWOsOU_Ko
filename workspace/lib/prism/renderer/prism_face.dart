import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../model/prism_models.dart';

class PrismFaceSpec {
  const PrismFaceSpec({
    required this.faceId,
    required this.size,
    required this.crop,
  });

  final PrismFaceId faceId;
  final Size size;
  final Rect crop;
}

class PrismFace extends StatelessWidget {
  const PrismFace({super.key, required this.image, required this.spec});

  final ui.Image image;
  final PrismFaceSpec spec;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: spec.size.width,
      height: spec.size.height,
      child: ClipRect(
        child: CustomPaint(
          size: spec.size,
          painter: _PrismFacePainter(image: image, crop: spec.crop),
        ),
      ),
    );
  }
}

class _PrismFacePainter extends CustomPainter {
  const _PrismFacePainter({required this.image, required this.crop});

  final ui.Image image;
  final Rect crop;

  @override
  void paint(Canvas canvas, Size size) {
    final sourceRect = Rect.fromLTWH(
      crop.left * image.width,
      crop.top * image.height,
      crop.width * image.width,
      crop.height * image.height,
    );

    canvas.drawImageRect(
      image,
      sourceRect,
      Offset.zero & size,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(covariant _PrismFacePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.crop != crop;
  }
}
