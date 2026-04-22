import 'package:flutter/material.dart';

import 'prism_face_value_store.dart';
import 'prism_config.dart';
import 'prism_view_state.dart';

class PrismEditorController extends ChangeNotifier {
  bool _showFaceOverlays = false;
  String _selectedImageAssetPath = prismImageAssetPaths.first;
  PrismFaceId _selectedFace = PrismFaceId.stem;

  final PrismFaceValueStore _faceValueStore = PrismFaceValueStore();
  final PrismViewState _viewState = PrismViewState();

  bool get showFaceOverlays => _showFaceOverlays;
  String get selectedImageAssetPath => _selectedImageAssetPath;
  PrismFaceId get selectedFace => _selectedFace;
  double get rx => _viewState.rx;
  double get ry => _viewState.ry;
  double get rz => _viewState.rz;
  double get zoom => _viewState.zoom;

  PrismImageOption get selectedImageOption => prismImageOptions.firstWhere(
    (option) => option.assetPath == _selectedImageAssetPath,
  );

  Map<PrismFaceId, Rect> get activePrismFaceValues =>
      _faceValueStore.faceValuesFor(selectedImageOption.dimensions);

  Rect get selectedCrop => _faceValueStore.selectedCrop(
    dimensions: selectedImageOption.dimensions,
    selectedFace: _selectedFace,
  );

  void setImage(String value) {
    if (_selectedImageAssetPath == value) return;
    _selectedImageAssetPath = value;
    notifyListeners();
  }

  void setFace(PrismFaceId value) {
    if (_selectedFace == value) return;
    _selectedFace = value;
    notifyListeners();
  }

  void setShowFaceOverlays(bool value) {
    if (_showFaceOverlays == value) return;
    _showFaceOverlays = value;
    notifyListeners();
  }

  void setRx(double value) {
    if (_viewState.setRx(value)) notifyListeners();
  }

  void setRy(double value) {
    if (_viewState.setRy(value)) notifyListeners();
  }

  void setRz(double value) {
    if (_viewState.setRz(value)) notifyListeners();
  }

  void setZoom(double value) {
    if (_viewState.setZoom(value)) notifyListeners();
  }

  void rotateByDrag(DragUpdateDetails details) {
    if (_viewState.rotateByDrag(details)) notifyListeners();
  }

  void updateSelectedCrop({
    double? left,
    double? top,
    double? width,
    double? height,
  }) {
    if (
      _faceValueStore.updateSelectedCrop(
        dimensions: selectedImageOption.dimensions,
        selectedFace: _selectedFace,
        left: left,
        top: top,
        width: width,
        height: height,
      )
    ) {
      notifyListeners();
    }
  }
}
