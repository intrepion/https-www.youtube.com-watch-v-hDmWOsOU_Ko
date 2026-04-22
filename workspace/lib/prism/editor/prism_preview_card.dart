import 'package:flutter/material.dart';

import '../model/prism_models.dart';
import '../preview/prism_image_preview.dart';

class PrismPreviewCard extends StatelessWidget {
  const PrismPreviewCard({
    super.key,
    required this.imageAssetPath,
    required this.prismFaceValues,
    required this.selectedFace,
    required this.showFaceOverlays,
    required this.faceValuesVersion,
  });

  final String imageAssetPath;
  final Map<PrismFaceId, Rect> prismFaceValues;
  final PrismFaceId selectedFace;
  final bool showFaceOverlays;
  final int faceValuesVersion;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 240, maxHeight: 360),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: InteractiveViewer(
          constrained: false,
          minScale: 0.5,
          maxScale: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: PrismImagePreview(
              imageAssetPath: imageAssetPath,
              prismFaceValues: prismFaceValues,
              selectedFace: selectedFace,
              showFaceOverlays: showFaceOverlays,
              faceValuesVersion: faceValuesVersion,
            ),
          ),
        ),
      ),
    );
  }
}
