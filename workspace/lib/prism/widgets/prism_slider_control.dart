import 'package:flutter/material.dart';

class PrismSliderSpec {
  const PrismSliderSpec({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.valueText,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final String valueText;
}

class PrismSliderControl extends StatelessWidget {
  const PrismSliderControl({
    super.key,
    required this.label,
    required this.valueText,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final String label;
  final String valueText;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: $valueText'),
          Slider(value: value, min: min, max: max, onChanged: onChanged),
        ],
      ),
    );
  }
}

class PrismSliderGroup extends StatelessWidget {
  const PrismSliderGroup({super.key, required this.specs});

  final List<PrismSliderSpec> specs;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: specs
          .map(
            (spec) => PrismSliderControl(
              label: spec.label,
              valueText: spec.valueText,
              value: spec.value,
              min: spec.min,
              max: spec.max,
              onChanged: spec.onChanged,
            ),
          )
          .toList(growable: false),
    );
  }
}
