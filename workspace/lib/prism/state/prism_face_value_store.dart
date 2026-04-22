import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';

import '../config/prism_constants.dart';
import '../config/prism_face_presets.dart';
import '../model/prism_models.dart';

class PrismFaceValueStore {
  PrismFaceValueStore()
    : _prismFaceValuesByDimensions = {
        for (final entry in defaultPrismFaceValuesByDimensions.entries)
          entry.key: Map<PrismFaceId, Rect>.from(entry.value),
      };

  final Map<PrismDimensions, Map<PrismFaceId, Rect>> _prismFaceValuesByDimensions;
  int _version = 0;

  int get version => _version;

  Map<PrismFaceId, Rect> faceValuesFor(PrismDimensions dimensions) =>
      UnmodifiableMapView(_mutableFaceValuesFor(dimensions));

  Map<PrismFaceId, Rect> _mutableFaceValuesFor(PrismDimensions dimensions) =>
      _prismFaceValuesByDimensions[dimensions]!;

  Rect selectedCrop({
    required PrismDimensions dimensions,
    required PrismFaceId selectedFace,
  }) {
    return _mutableFaceValuesFor(dimensions)[selectedFace]!;
  }

  bool updateSelectedCrop({
    required PrismDimensions dimensions,
    required PrismFaceId selectedFace,
    double? left,
    double? top,
    double? width,
    double? height,
  }) {
    final prismFaceValues = _mutableFaceValuesFor(dimensions);
    final current = prismFaceValues[selectedFace]!;
    final nextLeft = (left ?? current.left).clamp(0.0, 1.0);
    final nextTop = (top ?? current.top).clamp(0.0, 1.0);
    final maxWidth = max(minimumCropExtent, 1.0 - nextLeft);
    final maxHeight = max(minimumCropExtent, 1.0 - nextTop);
    final nextWidth = (width ?? current.width).clamp(
      minimumCropExtent,
      maxWidth,
    );
    final nextHeight = (height ?? current.height).clamp(
      minimumCropExtent,
      maxHeight,
    );
    final nextCrop = Rect.fromLTWH(
      nextLeft,
      nextTop,
      nextWidth,
      nextHeight,
    );
    if (current == nextCrop) return false;
    prismFaceValues[selectedFace] = nextCrop;
    _version += 1;
    return true;
  }
}
