import 'package:flutter/material.dart';

import '../config/prism_image_catalog.dart';
import '../controls/prism_face_crop_controls.dart';
import '../controls/prism_rotation_controls.dart';
import '../state/prism_editor_controller.dart';
import '../state/prism_editor_snapshot.dart';
import 'prism_editor_layout.dart';
import 'prism_image_panel.dart';
import 'prism_viewport_panel.dart';

class PrismEditorPage extends StatefulWidget {
  const PrismEditorPage({super.key});

  @override
  State<PrismEditorPage> createState() => _PrismEditorPageState();
}

class _PrismEditorPageState extends State<PrismEditorPage> {
  late final PrismEditorController _controller = PrismEditorController();

  PrismRotationControls _buildPrismControls(PrismEditorSnapshot snapshot) {
    return PrismRotationControls(
      rx: snapshot.rx,
      ry: snapshot.ry,
      rz: snapshot.rz,
      zoom: snapshot.zoom,
      onRxChanged: _controller.setRx,
      onRyChanged: _controller.setRy,
      onRzChanged: _controller.setRz,
      onZoomChanged: _controller.setZoom,
    );
  }

  PrismFaceCropControls _buildFaceControls(PrismEditorSnapshot snapshot) {
    return PrismFaceCropControls(
      crop: snapshot.selectedCrop,
      onLeftChanged: (value) => _controller.updateSelectedCrop(left: value),
      onTopChanged: (value) => _controller.updateSelectedCrop(top: value),
      onWidthChanged: (value) => _controller.updateSelectedCrop(width: value),
      onHeightChanged: (value) => _controller.updateSelectedCrop(height: value),
    );
  }

  Widget _buildImagePanel(PrismEditorSnapshot snapshot) {
    return PrismImagePanel(
      selectedImageOption: snapshot.selectedImageOption,
      prismFaceValues: snapshot.activePrismFaceValues,
      selectedFace: snapshot.selectedFace,
      showFaceOverlays: snapshot.showFaceOverlays,
      showImagePreview: snapshot.showImagePreview,
      faceValuesVersion: snapshot.cropVersion,
      onFaceChanged: _controller.setFace,
      onShowFaceOverlaysChanged: _controller.setShowFaceOverlays,
      faceControls: _buildFaceControls(snapshot),
    );
  }

  Widget _buildPrismPanel(PrismEditorSnapshot snapshot) {
    return PrismViewportPanel(
      rx: snapshot.rx,
      ry: snapshot.ry,
      rz: snapshot.rz,
      zoom: snapshot.zoom,
      imageOption: snapshot.selectedImageOption,
      imageOptions: prismImageOptions,
      prismFaceValues: snapshot.activePrismFaceValues,
      showImagePreview: snapshot.showImagePreview,
      showTransformControls: snapshot.showTransformControls,
      onImageChanged: _controller.setImage,
      onShowImagePreviewChanged: _controller.setShowImagePreview,
      onShowTransformControlsChanged: _controller.setShowTransformControls,
      onPrismRotateDelta: _controller.rotateByDelta,
      onPrismScaleStart: _controller.startZoomGesture,
      onPrismScaleUpdate: _controller.scaleZoom,
      rotationControls: _buildPrismControls(snapshot),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final snapshot = _controller.snapshot;
        return Scaffold(
          body: SafeArea(
            child: PrismEditorLayout(
              imagePanel: snapshot.showImagePreview
                  ? _buildImagePanel(snapshot)
                  : null,
              prismPanel: _buildPrismPanel(snapshot),
            ),
          ),
        );
      },
    );
  }
}
