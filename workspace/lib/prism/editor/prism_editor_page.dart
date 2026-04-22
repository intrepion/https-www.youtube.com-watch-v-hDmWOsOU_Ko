import 'package:flutter/material.dart';

import '../config/prism_image_catalog.dart';
import '../controls/prism_face_crop_controls.dart';
import '../controls/prism_rotation_controls.dart';
import '../state/prism_editor_controller.dart';
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

  PrismRotationControls _buildPrismControls() {
    return PrismRotationControls(
      rx: _controller.rx,
      ry: _controller.ry,
      rz: _controller.rz,
      zoom: _controller.zoom,
      onRxChanged: _controller.setRx,
      onRyChanged: _controller.setRy,
      onRzChanged: _controller.setRz,
      onZoomChanged: _controller.setZoom,
    );
  }

  PrismFaceCropControls _buildFaceControls() {
    return PrismFaceCropControls(
      crop: _controller.selectedCrop,
      onLeftChanged: (value) => _controller.updateSelectedCrop(left: value),
      onTopChanged: (value) => _controller.updateSelectedCrop(top: value),
      onWidthChanged: (value) => _controller.updateSelectedCrop(width: value),
      onHeightChanged: (value) => _controller.updateSelectedCrop(height: value),
    );
  }

  Widget _buildImagePanel() {
    return PrismImagePanel(
      selectedImageAssetPath: _controller.selectedImageAssetPath,
      imageOptions: prismImageOptions,
      prismFaceValues: _controller.activePrismFaceValues,
      selectedFace: _controller.selectedFace,
      showFaceOverlays: _controller.showFaceOverlays,
      faceValuesVersion: _controller.cropVersion,
      onImageChanged: _controller.setImage,
      onFaceChanged: _controller.setFace,
      onShowFaceOverlaysChanged: _controller.setShowFaceOverlays,
      faceControls: _buildFaceControls(),
    );
  }

  Widget _buildPrismPanel() {
    return PrismViewportPanel(
      rx: _controller.rx,
      ry: _controller.ry,
      rz: _controller.rz,
      zoom: _controller.zoom,
      imageAssetPath: _controller.selectedImageAssetPath,
      dimensions: _controller.selectedImageOption.dimensions,
      prismFaceValues: _controller.activePrismFaceValues,
      rotationControls: _buildPrismControls(),
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
        return GestureDetector(
          onPanUpdate: _controller.rotateByDrag,
          child: Scaffold(
            body: SafeArea(
              child: PrismEditorLayout(
                imagePanel: _buildImagePanel(),
                prismPanel: _buildPrismPanel(),
              ),
            ),
          ),
        );
      },
    );
  }
}
