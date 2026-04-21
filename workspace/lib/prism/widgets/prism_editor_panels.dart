import 'package:flutter/material.dart';

import '../prism_config.dart';
import 'prism_image_preview.dart';
import 'rectangular_prism.dart';

class PrismLabeledField extends StatelessWidget {
  const PrismLabeledField({
    super.key,
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: child,
      ),
    );
  }
}

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
          PrismLabeledField(
            label: 'Image',
            child: DropdownButton<String>(
              value: selectedImageAssetPath,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: imageOptions.map((option) {
                return DropdownMenuItem<String>(
                  value: option.assetPath,
                  child: Text(option.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value == null) return;
                onImageChanged(value);
              },
            ),
          ),
          const SizedBox(height: 16),
          Padding(
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
                    imageAssetPath: selectedImageAssetPath,
                    prismFaceValues: Map<String, Rect>.from(prismFaceValues),
                    selectedFace: selectedFace,
                    showFaceOverlays: showFaceOverlays,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Face',
                      border: OutlineInputBorder(),
                    ),
                    child: DropdownButton<String>(
                      value: selectedFace,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      items: prismFaceDropdownLabels.entries.map((entry) {
                        return DropdownMenuItem<String>(
                          value: entry.key,
                          child: Text(entry.value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        onFaceChanged(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 170,
                  child: SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    title: const Text('Overlays'),
                    value: showFaceOverlays,
                    onChanged: onShowFaceOverlaysChanged,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...faceControls,
        ],
      ),
    );
  }
}

class PrismViewportPanel extends StatelessWidget {
  const PrismViewportPanel({
    super.key,
    required this.constraints,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.zoom,
    required this.imageAssetPath,
    required this.dimensions,
    required this.prismFaceValues,
    required this.controls,
  });

  final BoxConstraints constraints;
  final double rx;
  final double ry;
  final double rz;
  final double zoom;
  final String imageAssetPath;
  final PrismDimensions dimensions;
  final Map<String, Rect> prismFaceValues;
  final List<Widget> controls;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, panelConstraints) {
        final prismHeight =
            (panelConstraints.maxHeight * 0.52).clamp(180.0, 420.0);

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: panelConstraints.maxHeight),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: prismHeight,
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: RectangularPrism(
                          rx: rx,
                          ry: ry,
                          rz: rz,
                          zoom: zoom,
                          imageAssetPath: imageAssetPath,
                          dimensions: dimensions,
                          prismFaceValues: prismFaceValues,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ...controls,
              ],
            ),
          ),
        );
      },
    );
  }
}
