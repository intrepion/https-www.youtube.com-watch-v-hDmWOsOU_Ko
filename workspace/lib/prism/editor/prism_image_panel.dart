import 'package:flutter/material.dart';

import '../controls/prism_face_crop_controls.dart';
import '../model/prism_models.dart';
import 'prism_editor_constants.dart';
import 'prism_face_editor_section.dart';
import 'prism_preview_card.dart';

class PrismImagePanel extends StatelessWidget {
  const PrismImagePanel({
    super.key,
    required this.selectedImageOption,
    required this.prismFaceValues,
    required this.selectedFace,
    required this.showFaceOverlays,
    required this.showImagePreview,
    required this.faceValuesVersion,
    required this.onFaceChanged,
    required this.onShowFaceOverlaysChanged,
    required this.faceControls,
  });

  final PrismImageOption selectedImageOption;
  final Map<PrismFaceId, Rect> prismFaceValues;
  final PrismFaceId selectedFace;
  final bool showFaceOverlays;
  final bool showImagePreview;
  final int faceValuesVersion;
  final ValueChanged<PrismFaceId> onFaceChanged;
  final ValueChanged<bool> onShowFaceOverlaysChanged;
  final PrismFaceCropControls faceControls;

  @override
  Widget build(BuildContext context) {
    if (!showImagePreview) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        0,
        prismEditorPanelTopPadding,
        0,
        prismEditorPanelBottomPadding,
      ),
      child: Column(
        children: [
          PrismPreviewCard(
            imageOption: selectedImageOption,
            prismFaceValues: prismFaceValues,
            selectedFace: selectedFace,
            showFaceOverlays: showFaceOverlays,
            faceValuesVersion: faceValuesVersion,
          ),
          const SizedBox(height: prismEditorSectionSpacing),
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
