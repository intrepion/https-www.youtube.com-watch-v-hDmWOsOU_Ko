import 'package:flutter/material.dart';

import '../model/prism_models.dart';
import 'prism_labeled_field.dart';

class PrismImageSelector extends StatelessWidget {
  const PrismImageSelector({
    super.key,
    required this.selectedImageOption,
    required this.imageOptions,
    required this.onImageChanged,
  });

  final PrismImageOption selectedImageOption;
  final List<PrismImageOption> imageOptions;
  final ValueChanged<PrismImageOption> onImageChanged;

  @override
  Widget build(BuildContext context) {
    return PrismLabeledField(
      label: 'Image',
      child: DropdownButton<PrismImageOption>(
        key: const ValueKey('image-dropdown'),
        value: selectedImageOption,
        isExpanded: true,
        underline: const SizedBox.shrink(),
        items: imageOptions.map((option) {
          return DropdownMenuItem<PrismImageOption>(
            value: option,
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
