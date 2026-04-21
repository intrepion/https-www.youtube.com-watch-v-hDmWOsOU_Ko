import 'package:flutter/material.dart';

import '../prism_config.dart';
import 'prism_image_preview.dart';
import 'prism_labeled_field.dart';

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
