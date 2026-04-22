import 'package:flutter/material.dart';

import '../prism_config.dart';
import 'prism_labeled_field.dart';

class PrismImageSelector extends StatelessWidget {
  const PrismImageSelector({
    super.key,
    required this.selectedImageAssetPath,
    required this.imageOptions,
    required this.onImageChanged,
  });

  final String selectedImageAssetPath;
  final List<PrismImageOption> imageOptions;
  final ValueChanged<String> onImageChanged;

  @override
  Widget build(BuildContext context) {
    return PrismLabeledField(
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
    );
  }
}
