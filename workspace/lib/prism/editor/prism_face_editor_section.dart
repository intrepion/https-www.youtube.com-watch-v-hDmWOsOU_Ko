import 'package:flutter/material.dart';

import '../prism_config.dart';

class PrismFaceEditorSection extends StatelessWidget {
  const PrismFaceEditorSection({
    super.key,
    required this.selectedFace,
    required this.showFaceOverlays,
    required this.onFaceChanged,
    required this.onShowFaceOverlaysChanged,
    required this.controls,
  });

  final String selectedFace;
  final bool showFaceOverlays;
  final ValueChanged<String> onFaceChanged;
  final ValueChanged<bool> onShowFaceOverlaysChanged;
  final List<Widget> controls;

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
        ...controls,
      ],
    );
  }
}
