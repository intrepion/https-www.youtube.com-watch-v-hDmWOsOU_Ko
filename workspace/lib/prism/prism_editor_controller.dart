import 'dart:math';

import 'package:flutter/material.dart';

import 'prism_config.dart';

class PrismEditorController extends ChangeNotifier {
  double rx = 0.0;
  double ry = 0.0;
  double rz = 0.0;
  double zoom = 1.0;
  bool showFaceOverlays = false;
  String selectedImageAssetPath = prismImageAssetPaths.first;
  String selectedFace = 'stem';

  PrismEditorController()
    : _prismFaceValuesByDimensions = {
        for (final entry in defaultPrismFaceValuesByDimensions.entries)
          entry.key: Map<String, Rect>.from(entry.value),
      };

  final Map<String, Map<String, Rect>> _prismFaceValuesByDimensions;

  PrismImageOption get selectedImageOption => prismImageOptions.firstWhere(
    (option) => option.assetPath == selectedImageAssetPath,
  );

  Map<String, Rect> get activePrismFaceValues =>
      _prismFaceValuesByDimensions[selectedImageOption.dimensions.key]!;

  Rect get selectedCrop => activePrismFaceValues[selectedFace]!;

  void setImage(String value) {
    if (selectedImageAssetPath == value) return;
    selectedImageAssetPath = value;
    notifyListeners();
  }

  void setFace(String value) {
    if (selectedFace == value) return;
    selectedFace = value;
    notifyListeners();
  }

  void setShowFaceOverlays(bool value) {
    if (showFaceOverlays == value) return;
    showFaceOverlays = value;
    notifyListeners();
  }

  void setRx(double value) {
    if (rx == value) return;
    rx = value;
    notifyListeners();
  }

  void setRy(double value) {
    if (ry == value) return;
    ry = value;
    notifyListeners();
  }

  void setRz(double value) {
    if (rz == value) return;
    rz = value;
    notifyListeners();
  }

  void setZoom(double value) {
    if (zoom == value) return;
    zoom = value;
    notifyListeners();
  }

  void rotateByDrag(DragUpdateDetails details) {
    rx += details.delta.dy * 0.01;
    ry -= details.delta.dx * 0.01;
    rx %= pi * 2;
    ry %= pi * 2;
    notifyListeners();
  }

  void updateSelectedCrop({
    double? left,
    double? top,
    double? width,
    double? height,
  }) {
    final prismFaceValues = activePrismFaceValues;
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

    prismFaceValues[selectedFace] = Rect.fromLTWH(
      nextLeft,
      nextTop,
      nextWidth,
      nextHeight,
    );
    notifyListeners();
  }
}
