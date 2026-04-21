import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../prism_config.dart';

class PrismImagePreview extends StatefulWidget {
  const PrismImagePreview({
    super.key,
    required this.imageAssetPath,
    required this.prismFaceValues,
    required this.selectedFace,
    required this.showFaceOverlays,
  });

  final String imageAssetPath;
  final Map<String, Rect> prismFaceValues;
  final String selectedFace;
  final bool showFaceOverlays;

  @override
  State<PrismImagePreview> createState() => _PrismImagePreviewState();
}

class _PrismImagePreviewState extends State<PrismImagePreview> {
  ui.Image? _previewImage;
  ImageStream? _imageStream;
  late final ImageStreamListener _imageListener = ImageStreamListener((
    imageInfo,
    _,
  ) {
    if (!mounted) return;
    setState(() => _previewImage = imageInfo.image);
  });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolvePreviewImage();
  }

  @override
  void didUpdateWidget(covariant PrismImagePreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageAssetPath != widget.imageAssetPath) {
      _resolvePreviewImage();
    }
  }

  void _resolvePreviewImage() {
    final stream = AssetImage(
      widget.imageAssetPath,
    ).resolve(createLocalImageConfiguration(context));

    if (_imageStream?.key == stream.key) return;

    _imageStream?.removeListener(_imageListener);
    _imageStream = stream..addListener(_imageListener);
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_imageListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previewImage = _previewImage;
    if (previewImage == null) {
      return const SizedBox(
        width: 240,
        height: 240,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SizedBox(
      width: min(previewImage.width.toDouble(), 520.0),
      child: AspectRatio(
        aspectRatio: previewImage.width / previewImage.height,
        child: CustomPaint(
          foregroundPainter: widget.showFaceOverlays
              ? _PrismFaceOverlayPainter(
                  prismFaceValues: widget.prismFaceValues,
                  selectedFace: widget.selectedFace,
                )
              : null,
          child: Image.asset(widget.imageAssetPath, fit: BoxFit.fill),
        ),
      ),
    );
  }
}

class _PrismFaceOverlayPainter extends CustomPainter {
  const _PrismFaceOverlayPainter({
    required this.prismFaceValues,
    required this.selectedFace,
  });

  final Map<String, Rect> prismFaceValues;
  final String selectedFace;

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
        text: prismFaceDropdownLabels[entry.key] ?? entry.key,
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
  bool shouldRepaint(covariant _PrismFaceOverlayPainter oldDelegate) {
    return oldDelegate.selectedFace != selectedFace ||
        oldDelegate.prismFaceValues != prismFaceValues;
  }
}
