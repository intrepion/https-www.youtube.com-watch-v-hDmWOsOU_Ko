import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../controls/prism_rotation_controls.dart';
import '../model/prism_models.dart';
import '../renderer/rectangular_prism.dart';
import 'prism_editor_constants.dart';
import 'prism_image_selector.dart';

class PrismViewportPanel extends StatefulWidget {
  const PrismViewportPanel({
    super.key,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.zoom,
    required this.imageOption,
    required this.imageOptions,
    required this.prismFaceValues,
    required this.showImagePreview,
    required this.showTransformControls,
    required this.onImageChanged,
    required this.onShowImagePreviewChanged,
    required this.onShowTransformControlsChanged,
    required this.onPrismRotateDelta,
    required this.onPrismScaleStart,
    required this.onPrismScaleUpdate,
    required this.rotationControls,
  });

  final double rx;
  final double ry;
  final double rz;
  final double zoom;
  final PrismImageOption imageOption;
  final List<PrismImageOption> imageOptions;
  final Map<PrismFaceId, Rect> prismFaceValues;
  final bool showImagePreview;
  final bool showTransformControls;
  final ValueChanged<PrismImageOption> onImageChanged;
  final ValueChanged<bool> onShowImagePreviewChanged;
  final ValueChanged<bool> onShowTransformControlsChanged;
  final ValueChanged<Offset> onPrismRotateDelta;
  final VoidCallback onPrismScaleStart;
  final ValueChanged<double> onPrismScaleUpdate;
  final PrismRotationControls rotationControls;

  @override
  State<PrismViewportPanel> createState() => _PrismViewportPanelState();
}

class _PrismViewportPanelState extends State<PrismViewportPanel> {
  bool _gestureUsedZoom = false;

  void _handlePointerSignal(PointerSignalEvent event) {
    if (event is! PointerScaleEvent) return;
    widget.onPrismScaleStart();
    widget.onPrismScaleUpdate(event.scale);
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _gestureUsedZoom = false;
    widget.onPrismScaleStart();
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    final isZooming = details.pointerCount >= 2 || details.scale != 1.0;
    if (isZooming) {
      _gestureUsedZoom = true;
      widget.onPrismScaleUpdate(details.scale);
      return;
    }

    if (_gestureUsedZoom) return;
    widget.onPrismRotateDelta(details.focalPointDelta);
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _gestureUsedZoom = false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        0,
        prismEditorPanelTopPadding,
        0,
        prismEditorPanelBottomPadding,
      ),
      child: Column(
        children: [
          _ViewportToolbar(
            selectedImageOption: widget.imageOption,
            imageOptions: widget.imageOptions,
            showImagePreview: widget.showImagePreview,
            showTransformControls: widget.showTransformControls,
            onImageChanged: widget.onImageChanged,
            onShowImagePreviewChanged: widget.onShowImagePreviewChanged,
            onShowTransformControlsChanged:
                widget.onShowTransformControlsChanged,
          ),
          const SizedBox(height: prismViewportSectionSpacing),
          Expanded(
            child: Listener(
              onPointerSignal: _handlePointerSignal,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onScaleStart: _handleScaleStart,
                onScaleUpdate: _handleScaleUpdate,
                onScaleEnd: _handleScaleEnd,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Padding(
                      padding: const EdgeInsets.all(prismViewportInnerPadding),
                      child: RectangularPrism(
                        rx: widget.rx,
                        ry: widget.ry,
                        rz: widget.rz,
                        zoom: widget.zoom,
                        imageOption: widget.imageOption,
                        prismFaceValues: widget.prismFaceValues,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (widget.showTransformControls) ...[
            const SizedBox(height: prismViewportSectionSpacing),
            Flexible(
              child: SingleChildScrollView(child: widget.rotationControls),
            ),
          ],
        ],
      ),
    );
  }
}

class _ViewportToolbar extends StatelessWidget {
  const _ViewportToolbar({
    required this.selectedImageOption,
    required this.imageOptions,
    required this.showImagePreview,
    required this.showTransformControls,
    required this.onImageChanged,
    required this.onShowImagePreviewChanged,
    required this.onShowTransformControlsChanged,
  });

  final PrismImageOption selectedImageOption;
  final List<PrismImageOption> imageOptions;
  final bool showImagePreview;
  final bool showTransformControls;
  final ValueChanged<PrismImageOption> onImageChanged;
  final ValueChanged<bool> onShowImagePreviewChanged;
  final ValueChanged<bool> onShowTransformControlsChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrismImageSelector(
            selectedImageOption: selectedImageOption,
            imageOptions: imageOptions,
            onImageChanged: onImageChanged,
          ),
        ),
        const SizedBox(width: 8),
        _ToolbarToggle(
          switchKey: const ValueKey('show-image-preview-switch'),
          label: '2D',
          value: showImagePreview,
          onChanged: onShowImagePreviewChanged,
        ),
        _ToolbarToggle(
          switchKey: const ValueKey('show-transform-controls-switch'),
          label: 'Sliders',
          value: showTransformControls,
          onChanged: onShowTransformControlsChanged,
        ),
      ],
    );
  }
}

class _ToolbarToggle extends StatelessWidget {
  const _ToolbarToggle({
    required this.switchKey,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final Key switchKey;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        Switch(key: switchKey, value: value, onChanged: onChanged),
      ],
    );
  }
}
