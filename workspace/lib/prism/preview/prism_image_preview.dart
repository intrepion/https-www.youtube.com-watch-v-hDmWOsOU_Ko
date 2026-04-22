import 'dart:math';

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
        return SizedBox(
          width: min(previewImage.width.toDouble(), prismPreviewMaxWidth),
          child: AspectRatio(
            aspectRatio: previewImage.width / previewImage.height,
            child: CustomPaint(
              foregroundPainter: showFaceOverlays
                  ? PrismFaceOverlayPainter(
                      prismFaceValues: prismFaceValues,
                      selectedFace: selectedFace,
                      faceValuesVersion: faceValuesVersion,
                    )
                  : null,
              child: Image.asset(imageOption.assetPath, fit: BoxFit.fill),
            ),
          ),
        );
      },
    );
  }
}
