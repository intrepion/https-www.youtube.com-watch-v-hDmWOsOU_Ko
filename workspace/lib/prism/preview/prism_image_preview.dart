import 'dart:math';

import 'package:flutter/material.dart';

import '../editor/prism_editor_constants.dart';
import '../model/prism_models.dart';
import 'asset_load_placeholder.dart';
import 'asset_ui_image_loader.dart';
import 'prism_face_overlay_painter.dart';

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
    return AssetUiImageLoader(
      assetPath: imageOption.assetPath,
      builder: (context, loadState) {
        if (loadState.hasError) {
          return const AssetLoadPlaceholder.error(
            width: prismPreviewPlaceholderExtent,
            height: prismPreviewPlaceholderExtent,
          );
        }

        final previewImage = loadState.image;
        if (loadState.isLoading || previewImage == null) {
          return const AssetLoadPlaceholder.loading(
            width: prismPreviewPlaceholderExtent,
            height: prismPreviewPlaceholderExtent,
          );
        }

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
