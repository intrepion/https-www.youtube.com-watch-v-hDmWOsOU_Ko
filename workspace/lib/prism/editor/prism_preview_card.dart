import 'package:flutter/material.dart';

import 'prism_editor_constants.dart';
import '../model/prism_models.dart';
import '../preview/prism_image_preview.dart';

class PrismPreviewCard extends StatelessWidget {
  const PrismPreviewCard({
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: prismPreviewHorizontalPadding),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: prismPreviewMinHeight,
          maxHeight: prismPreviewMaxHeight,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(prismPreviewBorderRadius),
        ),
        clipBehavior: Clip.antiAlias,
        child: InteractiveViewer(
          constrained: false,
          minScale: prismPreviewMinScale,
          maxScale: prismPreviewMaxScale,
          child: Padding(
            padding: const EdgeInsets.all(prismPreviewInnerPadding),
            child: RepaintBoundary(
              child: PrismImagePreview(
                imageOption: imageOption,
                prismFaceValues: prismFaceValues,
                selectedFace: selectedFace,
                showFaceOverlays: showFaceOverlays,
                faceValuesVersion: faceValuesVersion,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
