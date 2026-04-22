import 'package:flutter/material.dart';

import '../config/prism_face_presets.dart';
import '../model/prism_models.dart';

class PrismFaceEditorSection extends StatelessWidget {
  const PrismFaceEditorSection({
    super.key,
    required this.selectedFace,
    required this.showFaceOverlays,
    required this.onFaceChanged,
    required this.onShowFaceOverlaysChanged,
    required this.controls,
  });

  final PrismFaceId selectedFace;
  final bool showFaceOverlays;
  final ValueChanged<PrismFaceId> onFaceChanged;
  final ValueChanged<bool> onShowFaceOverlaysChanged;
  final Widget controls;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                  child: DropdownButton<PrismFaceId>(
                    key: const ValueKey('face-dropdown'),
                    value: selectedFace,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    items: PrismFaceId.values.map((faceId) {
                      return DropdownMenuItem<PrismFaceId>(
                        value: faceId,
                        child: Text(
                          prismFaceDropdownLabels[faceId] ?? faceId.label,
                        ),
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
                  key: const ValueKey('show-face-overlays-switch'),
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
        controls,
      ],
    );
  }
}
