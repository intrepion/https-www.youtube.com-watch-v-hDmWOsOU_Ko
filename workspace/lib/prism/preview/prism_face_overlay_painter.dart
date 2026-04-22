import 'dart:math';

import 'package:flutter/material.dart';

import '../config/prism_face_presets.dart';
import '../model/prism_models.dart';

class PrismFaceOverlayPainter extends CustomPainter {
  const PrismFaceOverlayPainter({
    required this.prismFaceValues,
    required this.selectedFace,
    required this.faceValuesVersion,
  });

  final Map<PrismFaceId, Rect> prismFaceValues;
  final PrismFaceId selectedFace;
  final int faceValuesVersion;

  @override
  void paint(Canvas canvas, Size size) {
    final labelPainter = TextPainter(textDirection: TextDirection.ltr);

    for (final entry in prismFaceValues.entries) {
      final color = prismFaceOverlayColors[entry.key] ?? Colors.white;
      final crop = entry.value;
      final overlayRect = Rect.fromLTWH(
        crop.left * size.width,
        crop.top * size.height,
        crop.width * size.width,
        crop.height * size.height,
      );
      final isSelected = entry.key == selectedFace;
      final strokePaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? 4 : 2;
      final fillPaint = Paint()
        ..color = color.withValues(alpha: isSelected ? 0.18 : 0.08)
        ..style = PaintingStyle.fill;

      canvas.drawRect(overlayRect, fillPaint);
      canvas.drawRect(overlayRect, strokePaint);

      labelPainter.text = TextSpan(
        text: prismFaceDropdownLabels[entry.key] ?? entry.key.label,
        style: TextStyle(
          color: Colors.white,
          fontSize: isSelected ? 13 : 11,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          backgroundColor: color.withValues(alpha: 0.85),
        ),
      );
      labelPainter.layout(maxWidth: max(0.0, overlayRect.width - 8));
      labelPainter.paint(
        canvas,
        Offset(overlayRect.left + 4, overlayRect.top + 4),
      );
    }
  }

  @override
  bool shouldRepaint(covariant PrismFaceOverlayPainter oldDelegate) {
    return oldDelegate.selectedFace != selectedFace ||
        oldDelegate.faceValuesVersion != faceValuesVersion ||
        !identical(oldDelegate.prismFaceValues, prismFaceValues);
  }
}
