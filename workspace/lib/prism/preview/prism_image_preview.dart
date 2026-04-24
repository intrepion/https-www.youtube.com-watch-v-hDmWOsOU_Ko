import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../editor/prism_editor_constants.dart';
import '../model/prism_models.dart';
import 'prism_face_overlay_painter.dart';
import 'resolved_asset_image_view.dart';

class PrismImagePreview extends StatelessWidget {
  const PrismImagePreview({
    super.key,
    required this.imageOption,
    required this.prismFaceValues,
    required this.selectedFace,
    required this.showFaceOverlays,
    required this.faceValuesVersion,
  });

  final PrismImageOption imageOption;
  final Map<PrismFaceId, Rect> prismFaceValues;
  final PrismFaceId selectedFace;
  final bool showFaceOverlays;
  final int faceValuesVersion;

  @override
  Widget build(BuildContext context) {
    return ResolvedAssetImageView(
      assetPath: imageOption.assetPath,
      loadingWidth: prismPreviewPlaceholderExtent,
      loadingHeight: prismPreviewPlaceholderExtent,
      errorWidth: prismPreviewPlaceholderExtent,
      errorHeight: prismPreviewPlaceholderExtent,
      builder: (context, previewImage) {
        return ResolvedPrismImagePreview(
          image: previewImage,
          assetPath: imageOption.assetPath,
          prismFaceValues: prismFaceValues,
          selectedFace: selectedFace,
          showFaceOverlays: showFaceOverlays,
          faceValuesVersion: faceValuesVersion,
        );
      },
    );
  }
}

class ResolvedPrismImagePreview extends StatelessWidget {
  const ResolvedPrismImagePreview({
    super.key,
    required this.image,
    required this.assetPath,
    required this.prismFaceValues,
    required this.selectedFace,
    required this.showFaceOverlays,
    required this.faceValuesVersion,
  });

  final ui.Image image;
  final String assetPath;
  final Map<PrismFaceId, Rect> prismFaceValues;
  final PrismFaceId selectedFace;
  final bool showFaceOverlays;
  final int faceValuesVersion;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: min(image.width.toDouble(), prismPreviewMaxWidth),
      child: AspectRatio(
        aspectRatio: image.width / image.height,
        child: CustomPaint(
          foregroundPainter: showFaceOverlays
              ? PrismFaceOverlayPainter(
                  prismFaceValues: prismFaceValues,
                  selectedFace: selectedFace,
                  faceValuesVersion: faceValuesVersion,
                )
              : null,
          child: Image.asset(assetPath, fit: BoxFit.fill),
        ),
      ),
    );
  }
}
