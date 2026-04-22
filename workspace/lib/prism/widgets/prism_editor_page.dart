import 'package:flutter/material.dart';

import '../prism_editor_controller.dart';
import '../prism_config.dart';
import 'prism_controls.dart';
import 'prism_image_panel.dart';
import 'prism_viewport_panel.dart';

class PrismEditorPage extends StatefulWidget {
  const PrismEditorPage({super.key});

  @override
  State<PrismEditorPage> createState() => _PrismEditorPageState();
}

class _PrismEditorPageState extends State<PrismEditorPage> {
  late final PrismEditorController _controller = PrismEditorController();

  List<Widget> _buildPrismControls() {
    return [
      PrismRotationControls(
        rx: _controller.rx,
        ry: _controller.ry,
        rz: _controller.rz,
        zoom: _controller.zoom,
        onRxChanged: _controller.setRx,
        onRyChanged: _controller.setRy,
        onRzChanged: _controller.setRz,
        onZoomChanged: _controller.setZoom,
      ),
    ];
  }

  List<Widget> _buildFaceControls() {
    return [
      PrismFaceCropControls(
        crop: _controller.selectedCrop,
        onLeftChanged: (value) => _controller.updateSelectedCrop(left: value),
        onTopChanged: (value) => _controller.updateSelectedCrop(top: value),
        onWidthChanged: (value) => _controller.updateSelectedCrop(width: value),
        onHeightChanged: (value) =>
            _controller.updateSelectedCrop(height: value),
      ),
    ];
  }

  Widget _buildImagePanel() {
    return PrismImagePanel(
      selectedImageAssetPath: _controller.selectedImageAssetPath,
      imageOptions: prismImageOptions,
      prismFaceValues: _controller.activePrismFaceValues,
      selectedFace: _controller.selectedFace,
      showFaceOverlays: _controller.showFaceOverlays,
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
      controls: _buildPrismControls(),
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWideLayout = constraints.maxWidth >= 960;

                  if (isWideLayout) {
                    return Row(
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 560),
                            child: _buildImagePanel(),
                          ),
                        ),
                        const VerticalDivider(width: 1),
                        Expanded(child: _buildPrismPanel()),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      Expanded(child: _buildImagePanel()),
                      const Divider(height: 1),
                      Expanded(child: _buildPrismPanel()),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
