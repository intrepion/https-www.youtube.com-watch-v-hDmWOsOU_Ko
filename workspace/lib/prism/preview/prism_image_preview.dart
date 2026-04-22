import 'dart:math';

import 'package:flutter/material.dart';

import '../model/prism_models.dart';
import 'asset_ui_image_loader.dart';
import 'prism_face_overlay_painter.dart';

class PrismImagePreview extends StatelessWidget {
  const PrismImagePreview({
    super.key,
    required this.imageAssetPath,
    required this.prismFaceValues,
    required this.selectedFace,
    required this.showFaceOverlays,
  });

  final String imageAssetPath;
  final Map<PrismFaceId, Rect> prismFaceValues;
  final PrismFaceId selectedFace;
  final bool showFaceOverlays;

  @override
  Widget build(BuildContext context) {
    return AssetUiImageLoader(
      assetPath: imageAssetPath,
      builder: (context, previewImage) {
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
              foregroundPainter: showFaceOverlays
                  ? PrismFaceOverlayPainter(
                      prismFaceValues: prismFaceValues,
                      selectedFace: selectedFace,
                    )
                  : null,
              child: Image.asset(imageAssetPath, fit: BoxFit.fill),
            ),
          ),
        );
      },
    );
  }
}
