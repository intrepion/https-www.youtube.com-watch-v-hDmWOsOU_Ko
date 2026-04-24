import 'dart:math';

import 'package:flutter/material.dart';

import '../state/prism_view_state.dart';
import 'prism_slider_control.dart';

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

  @override
  Widget build(BuildContext context) {
    return PrismSliderGroup(
      specs: [
        PrismSliderSpec(
          label: 'X',
          valueText: _formatAngle(rx),
          value: rx,
          min: pi * -2,
          max: pi * 2,
          onChanged: onRxChanged,
        ),
        PrismSliderSpec(
          label: 'Y',
          valueText: _formatAngle(ry),
          value: ry,
          min: pi * -2,
          max: pi * 2,
          onChanged: onRyChanged,
        ),
        PrismSliderSpec(
          label: 'Z',
          valueText: _formatAngle(rz),
          value: rz,
          min: pi * -2,
          max: pi * 2,
          onChanged: onRzChanged,
        ),
        PrismSliderSpec(
          label: 'Zoom',
          valueText: _formatZoom(zoom),
          value: zoom,
          min: prismMinZoom,
          max: prismMaxZoom,
          onChanged: onZoomChanged,
        ),
      ],
    );
  }
}

String _formatAngle(double radians) {
  final degrees = radians * 180 / pi;
  return '${radians.toStringAsFixed(2)} rad (${degrees.toStringAsFixed(1)} deg)';
}

String _formatZoom(double value) => '${value.toStringAsFixed(2)}x';
