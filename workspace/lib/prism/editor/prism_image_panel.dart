import 'package:flutter/material.dart';

import '../controls/prism_face_crop_controls.dart';
import '../model/prism_models.dart';
import 'prism_face_editor_section.dart';
import 'prism_image_selector.dart';
import 'prism_preview_card.dart';

class PrismImagePanel extends StatelessWidget {
  const PrismImagePanel({
    super.key,
    required this.selectedImageAssetPath,
    required this.imageOptions,
    required this.prismFaceValues,
    required this.selectedFace,
    required this.showFaceOverlays,
    required this.faceValuesVersion,
    required this.onImageChanged,
    required this.onFaceChanged,
    required this.onShowFaceOverlaysChanged,
    required this.faceControls,
  });

  final String selectedImageAssetPath;
  final List<PrismImageOption> imageOptions;
  final Map<PrismFaceId, Rect> prismFaceValues;
  final PrismFaceId selectedFace;
  final bool showFaceOverlays;
  final int faceValuesVersion;
  final ValueChanged<String> onImageChanged;
  final ValueChanged<PrismFaceId> onFaceChanged;
  final ValueChanged<bool> onShowFaceOverlaysChanged;
  final PrismFaceCropControls faceControls;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
      child: Column(
        children: [
          PrismImageSelector(
            selectedImageAssetPath: selectedImageAssetPath,
            imageOptions: imageOptions,
            onImageChanged: onImageChanged,
          ),
          const SizedBox(height: 16),
          PrismPreviewCard(
            imageAssetPath: selectedImageAssetPath,
            prismFaceValues: prismFaceValues,
            selectedFace: selectedFace,
            showFaceOverlays: showFaceOverlays,
            faceValuesVersion: faceValuesVersion,
          ),
          const SizedBox(height: 16),
          PrismFaceEditorSection(
            selectedFace: selectedFace,
            showFaceOverlays: showFaceOverlays,
            onFaceChanged: onFaceChanged,
            onShowFaceOverlaysChanged: onShowFaceOverlaysChanged,
            controls: faceControls,
          ),
        ],
      ),
    );
  }
}
