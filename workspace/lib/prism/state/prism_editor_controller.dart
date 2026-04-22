import 'package:flutter/material.dart';

import '../config/prism_image_catalog.dart';
import '../model/prism_models.dart';
import 'prism_face_value_store.dart';
import 'prism_view_state.dart';

class PrismEditorController extends ChangeNotifier {
  bool _showFaceOverlays = false;
  String _selectedImageAssetPath = prismImageAssetPaths.first;
  PrismFaceId _selectedFace = PrismFaceId.stem;

  final PrismFaceValueStore _faceValueStore = PrismFaceValueStore();
  final PrismViewState _viewState = PrismViewState();

  bool get showFaceOverlays => _showFaceOverlays;
  String get selectedImageAssetPath => selectedImageOption.assetPath;
  PrismFaceId get selectedFace => _selectedFace;
  int get cropVersion => _faceValueStore.version;
  double get rx => _viewState.rx;
  double get ry => _viewState.ry;
  double get rz => _viewState.rz;
  double get zoom => _viewState.zoom;

  PrismImageOption? _findImageOption(String assetPath) {
    for (final option in prismImageOptions) {
      if (option.assetPath == assetPath) return option;
    }
    return null;
  }

  PrismImageOption get _fallbackImageOption {
    if (prismImageOptions.isEmpty) {
      throw StateError('No prism image options configured.');
    }
    return prismImageOptions.first;
  }

  PrismImageOption get selectedImageOption =>
      _findImageOption(_selectedImageAssetPath) ?? _fallbackImageOption;

  Map<PrismFaceId, Rect> get activePrismFaceValues =>
      _faceValueStore.faceValuesFor(selectedImageOption.dimensions);

  Rect get selectedCrop => _faceValueStore.selectedCrop(
    dimensions: selectedImageOption.dimensions,
    selectedFace: _selectedFace,
  );

  void _setValue<T>(T current, T next, void Function(T value) assign) {
    if (current == next) return;
    assign(next);
    notifyListeners();
  }

  void _notifyIfChanged(bool changed) {
    if (changed) notifyListeners();
  }

  void setImage(String value) {
    final option = _findImageOption(value);
    if (option == null) return;
    _setValue(_selectedImageAssetPath, option.assetPath, (next) {
      _selectedImageAssetPath = next;
    });
  }

  void setFace(PrismFaceId value) {
    _setValue(_selectedFace, value, (next) {
      _selectedFace = next;
    });
  }

  void setShowFaceOverlays(bool value) {
    _setValue(_showFaceOverlays, value, (next) {
      _showFaceOverlays = next;
    });
  }

  void setRx(double value) {
    _notifyIfChanged(_viewState.setRx(value));
  }

  void setRy(double value) {
    _notifyIfChanged(_viewState.setRy(value));
  }

  void setRz(double value) {
    _notifyIfChanged(_viewState.setRz(value));
  }

  void setZoom(double value) {
    _notifyIfChanged(_viewState.setZoom(value));
  }

  void rotateByDrag(DragUpdateDetails details) {
    _notifyIfChanged(_viewState.rotateByDrag(details));
  }

  void updateSelectedCrop({
    double? left,
    double? top,
    double? width,
    double? height,
  }) {
    _notifyIfChanged(
      _faceValueStore.updateSelectedCrop(
        dimensions: selectedImageOption.dimensions,
        selectedFace: _selectedFace,
        left: left,
        top: top,
        width: width,
        height: height,
      ),
    );
  }
}
