import 'package:flutter/material.dart';

import '../config/prism_constants.dart';
import 'prism_slider_control.dart';

class PrismFaceCropControls extends StatelessWidget {
  const PrismFaceCropControls({
    super.key,
    required this.crop,
    required this.onLeftChanged,
    required this.onTopChanged,
    required this.onWidthChanged,
    required this.onHeightChanged,
  });

  final Rect crop;
  final ValueChanged<double> onLeftChanged;
  final ValueChanged<double> onTopChanged;
  final ValueChanged<double> onWidthChanged;
  final ValueChanged<double> onHeightChanged;

  @override
  Widget build(BuildContext context) {
    return PrismSliderGroup(
      specs: [
        PrismSliderSpec(
          label: 'Left',
          valueText: _formatCropValue(crop.left),
          value: crop.left,
          min: 0.0,
          max: 1.0,
          onChanged: onLeftChanged,
        ),
        PrismSliderSpec(
          label: 'Top',
          valueText: _formatCropValue(crop.top),
          value: crop.top,
          min: 0.0,
          max: 1.0,
          onChanged: onTopChanged,
        ),
        PrismSliderSpec(
          label: 'Width',
          valueText: _formatCropValue(crop.width),
          value: crop.width,
          min: minimumCropExtent,
          max: 1.0,
          onChanged: onWidthChanged,
        ),
        PrismSliderSpec(
          label: 'Height',
          valueText: _formatCropValue(crop.height),
          value: crop.height,
          min: minimumCropExtent,
          max: 1.0,
          onChanged: onHeightChanged,
        ),
      ],
    );
  }
}

String _formatCropValue(double value) => value.toStringAsFixed(4);
