import 'package:flutter/material.dart';

import '../model/prism_models.dart';

class PrismEditorSnapshot {
  const PrismEditorSnapshot({
    required this.selectedImageOption,
    required this.selectedFace,
    required this.showFaceOverlays,
    required this.showImagePreview,
    required this.showTransformControls,
    required this.cropVersion,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.zoom,
    required this.activePrismFaceValues,
    required this.selectedCrop,
  });

  final PrismImageOption selectedImageOption;
  final PrismFaceId selectedFace;
  final bool showFaceOverlays;
  final bool showImagePreview;
  final bool showTransformControls;
  final int cropVersion;
  final double rx;
  final double ry;
  final double rz;
  final double zoom;
  final Map<PrismFaceId, Rect> activePrismFaceValues;
  final Rect selectedCrop;

  String get selectedImageAssetPath => selectedImageOption.assetPath;
  PrismDimensions get dimensions => selectedImageOption.dimensions;
}
