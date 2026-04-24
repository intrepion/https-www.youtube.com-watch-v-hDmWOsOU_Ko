import 'package:flutter/material.dart';

import '../controls/prism_rotation_controls.dart';
import '../model/prism_models.dart';
import '../renderer/rectangular_prism.dart';
import 'prism_editor_constants.dart';
import 'prism_image_selector.dart';

class PrismViewportPanel extends StatelessWidget {
  const PrismViewportPanel({
    super.key,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.zoom,
    required this.imageOption,
    required this.imageOptions,
    required this.prismFaceValues,
    required this.showImagePreview,
    required this.showTransformControls,
    required this.onImageChanged,
    required this.onShowImagePreviewChanged,
    required this.onShowTransformControlsChanged,
    required this.rotationControls,
  });

  final double rx;
  final double ry;
  final double rz;
  final double zoom;
  final PrismImageOption imageOption;
  final List<PrismImageOption> imageOptions;
  final Map<PrismFaceId, Rect> prismFaceValues;
  final bool showImagePreview;
  final bool showTransformControls;
  final ValueChanged<PrismImageOption> onImageChanged;
  final ValueChanged<bool> onShowImagePreviewChanged;
  final ValueChanged<bool> onShowTransformControlsChanged;
  final PrismRotationControls rotationControls;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, panelConstraints) {
        final prismHeight =
            (panelConstraints.maxHeight * prismViewportHeightFactor).clamp(
              prismViewportMinHeight,
              prismViewportMaxHeight,
            );

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            0,
            prismEditorPanelTopPadding,
            0,
            prismEditorPanelBottomPadding,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: panelConstraints.maxHeight),
            child: Column(
              children: [
                _ViewportToolbar(
                  selectedImageOption: imageOption,
                  imageOptions: imageOptions,
                  showImagePreview: showImagePreview,
                  showTransformControls: showTransformControls,
                  onImageChanged: onImageChanged,
                  onShowImagePreviewChanged: onShowImagePreviewChanged,
                  onShowTransformControlsChanged:
                      onShowTransformControlsChanged,
                ),
                const SizedBox(height: prismViewportSectionSpacing),
                SizedBox(
                  width: double.infinity,
                  height: prismHeight,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          prismViewportInnerPadding,
                        ),
                        child: RectangularPrism(
                          rx: rx,
                          ry: ry,
                          rz: rz,
                          zoom: zoom,
                          imageOption: imageOption,
                          prismFaceValues: prismFaceValues,
                        ),
                      ),
                    ),
                  ),
                ),
                if (showTransformControls) ...[
                  const SizedBox(height: prismViewportSectionSpacing),
                  rotationControls,
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ViewportToolbar extends StatelessWidget {
  const _ViewportToolbar({
    required this.selectedImageOption,
    required this.imageOptions,
    required this.showImagePreview,
    required this.showTransformControls,
    required this.onImageChanged,
    required this.onShowImagePreviewChanged,
    required this.onShowTransformControlsChanged,
  });

  final PrismImageOption selectedImageOption;
  final List<PrismImageOption> imageOptions;
  final bool showImagePreview;
  final bool showTransformControls;
  final ValueChanged<PrismImageOption> onImageChanged;
  final ValueChanged<bool> onShowImagePreviewChanged;
  final ValueChanged<bool> onShowTransformControlsChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrismImageSelector(
            selectedImageOption: selectedImageOption,
            imageOptions: imageOptions,
            onImageChanged: onImageChanged,
          ),
        ),
        const SizedBox(width: 8),
        _ToolbarToggle(
          switchKey: const ValueKey('show-image-preview-switch'),
          label: '2D',
          value: showImagePreview,
          onChanged: onShowImagePreviewChanged,
        ),
        _ToolbarToggle(
          switchKey: const ValueKey('show-transform-controls-switch'),
          label: 'Sliders',
          value: showTransformControls,
          onChanged: onShowTransformControlsChanged,
        ),
      ],
    );
  }
}

class _ToolbarToggle extends StatelessWidget {
  const _ToolbarToggle({
    required this.switchKey,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final Key switchKey;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        Switch(key: switchKey, value: value, onChanged: onChanged),
      ],
    );
  }
}
