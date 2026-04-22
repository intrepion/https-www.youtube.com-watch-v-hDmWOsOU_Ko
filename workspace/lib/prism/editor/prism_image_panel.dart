import 'package:flutter/material.dart';

import '../prism_config.dart';
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
    required this.onImageChanged,
    required this.onFaceChanged,
    required this.onShowFaceOverlaysChanged,
    required this.faceControls,
  });

  final String selectedImageAssetPath;
  final List<PrismImageOption> imageOptions;
  final Map<String, Rect> prismFaceValues;
  final String selectedFace;
  final bool showFaceOverlays;
  final ValueChanged<String> onImageChanged;
  final ValueChanged<String> onFaceChanged;
  final ValueChanged<bool> onShowFaceOverlaysChanged;
  final List<Widget> faceControls;

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
