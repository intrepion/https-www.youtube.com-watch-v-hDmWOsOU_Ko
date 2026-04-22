import 'package:flutter/material.dart';

import '../config/prism_image_catalog.dart';
import '../model/prism_models.dart';
import 'prism_editor_snapshot.dart';
import 'prism_face_value_store.dart';
import 'prism_view_state.dart';

class PrismEditorController extends ChangeNotifier {
  bool _showFaceOverlays = false;
  PrismImageOption _selectedImageOption = _initialSelectedImageOption();
  PrismFaceId _selectedFace = PrismFaceId.stem;

  final PrismFaceValueStore _faceValueStore = PrismFaceValueStore();
  final PrismViewState _viewState = PrismViewState();

  PrismEditorSnapshot get snapshot => _buildSnapshot();

  PrismEditorSnapshot _buildSnapshot() => PrismEditorSnapshot(
    selectedImageOption: _selectedImageOption,
    selectedFace: _selectedFace,
    showFaceOverlays: _showFaceOverlays,
    cropVersion: _faceValueStore.version,
    rx: _viewState.rx,
    ry: _viewState.ry,
    rz: _viewState.rz,
    zoom: _viewState.zoom,
    activePrismFaceValues: _faceValueStore.faceValuesFor(
      _selectedImageOption.dimensions,
    ),
    selectedCrop: _faceValueStore.selectedCrop(
      dimensions: _selectedImageOption.dimensions,
      selectedFace: _selectedFace,
    ),
  );

  void _setValue<T>(T current, T next, void Function(T value) assign) {
    if (current == next) return;
    assign(next);
    notifyListeners();
  }

  void _notifyIfChanged(bool changed) {
    if (changed) notifyListeners();
  }

  void setImage(PrismImageOption value) {
    _setValue(_selectedImageOption, value, (next) {
      _selectedImageOption = next;
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
        dimensions: _selectedImageOption.dimensions,
        selectedFace: _selectedFace,
        left: left,
        top: top,
        width: width,
        height: height,
      ),
    );
  }
}

PrismImageOption _initialSelectedImageOption() {
  if (prismImageOptions.isEmpty) {
    throw StateError('No prism image options configured.');
  }
  return prismImageOptions.first;
}
