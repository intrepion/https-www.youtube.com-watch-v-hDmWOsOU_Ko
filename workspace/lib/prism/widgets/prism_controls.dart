import 'dart:math';

import 'package:flutter/material.dart';

import '../prism_config.dart';

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

class PrismRotationControls extends StatelessWidget {
  const PrismRotationControls({
    super.key,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.zoom,
    required this.onRxChanged,
    required this.onRyChanged,
    required this.onRzChanged,
    required this.onZoomChanged,
  });

  final double rx;
  final double ry;
  final double rz;
  final double zoom;
  final ValueChanged<double> onRxChanged;
  final ValueChanged<double> onRyChanged;
  final ValueChanged<double> onRzChanged;
  final ValueChanged<double> onZoomChanged;

  String _formatAngle(double radians) {
    final degrees = radians * 180 / pi;
    return '${radians.toStringAsFixed(2)} rad (${degrees.toStringAsFixed(1)} deg)';
  }

  String _formatZoom(double value) => '${value.toStringAsFixed(2)}x';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrismSliderControl(
          label: 'X',
          valueText: _formatAngle(rx),
          value: rx,
          min: pi * -2,
          max: pi * 2,
          onChanged: onRxChanged,
        ),
        PrismSliderControl(
          label: 'Y',
          valueText: _formatAngle(ry),
          value: ry,
          min: pi * -2,
          max: pi * 2,
          onChanged: onRyChanged,
        ),
        PrismSliderControl(
          label: 'Z',
          valueText: _formatAngle(rz),
          value: rz,
          min: pi * -2,
          max: pi * 2,
          onChanged: onRzChanged,
        ),
        PrismSliderControl(
          label: 'Zoom',
          valueText: _formatZoom(zoom),
          value: zoom,
          min: 0.4,
          max: 2.5,
          onChanged: onZoomChanged,
        ),
      ],
    );
  }
}

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

  String _formatCropValue(double value) => value.toStringAsFixed(4);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrismSliderControl(
          label: 'Left',
          valueText: _formatCropValue(crop.left),
          value: crop.left,
          min: 0.0,
          max: 1.0,
          onChanged: onLeftChanged,
        ),
        PrismSliderControl(
          label: 'Top',
          valueText: _formatCropValue(crop.top),
          value: crop.top,
          min: 0.0,
          max: 1.0,
          onChanged: onTopChanged,
        ),
        PrismSliderControl(
          label: 'Width',
          valueText: _formatCropValue(crop.width),
          value: crop.width,
          min: minimumCropExtent,
          max: 1.0,
          onChanged: onWidthChanged,
        ),
        PrismSliderControl(
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
