import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../prism_config.dart';

class RectangularPrism extends StatefulWidget {
  const RectangularPrism({
    super.key,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.zoom,
    required this.imageAssetPath,
    required this.dimensions,
    required this.prismFaceValues,
  });

  final double rx;
  final double ry;
  final double rz;
  final double zoom;
  final String imageAssetPath;
  final PrismDimensions dimensions;
  final Map<String, Rect> prismFaceValues;

  @override
  State<RectangularPrism> createState() => _RectangularPrismState();
}

class _RectangularPrismState extends State<RectangularPrism> {
  ui.Image? _prismImage;
  ImageStream? _imageStream;
  late final ImageStreamListener _imageListener = ImageStreamListener((
    imageInfo,
    _,
  ) {
    if (!mounted) return;
    setState(() => _prismImage = imageInfo.image);
  });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolvePrismImage();
  }

  @override
  void didUpdateWidget(covariant RectangularPrism oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageAssetPath != widget.imageAssetPath) {
      _resolvePrismImage();
    }
  }

  void _resolvePrismImage() {
    final stream = AssetImage(
      widget.imageAssetPath,
    ).resolve(createLocalImageConfiguration(context));

    if (_imageStream?.key == stream.key) return;

    _imageStream?.removeListener(_imageListener);
    _imageStream = stream..addListener(_imageListener);
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_imageListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prismImage = _prismImage;
    final halfWidth = widget.dimensions.topFaceSize.width / 2;
    final halfDepth = widget.dimensions.topFaceSize.height / 2;
    final halfHeight = widget.dimensions.sideFaceSize.height / 2;

    if (prismImage == null) {
      return SizedBox(
        width: widget.dimensions.width.toDouble(),
        height: widget.dimensions.height.toDouble(),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final prismRotation = Matrix4.identity()
      ..rotateX(widget.rx)
      ..rotateY(widget.ry)
      ..rotateZ(widget.rz);
    final prismTransform = Matrix4.identity()
      ..setEntry(3, 2, prismPerspectiveStrength)
      ..multiply(prismRotation)
      ..scaleByDouble(widget.zoom, widget.zoom, widget.zoom, 1.0);
    final orderedFaces = _orderedFaces(
      image: prismImage,
      rotation: prismRotation,
      halfWidth: halfWidth,
      halfDepth: halfDepth,
      halfHeight: halfHeight,
    );
    return Transform(
      transform: prismTransform,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: orderedFaces.map((face) {
          return Transform(
            transform: face.transform,
            alignment: Alignment.center,
            child: face.child,
          );
        }).toList(),
      ),
    );
  }

  List<_OrderedPrismFace> _orderedFaces({
    required ui.Image image,
    required Matrix4 rotation,
    required double halfWidth,
    required double halfDepth,
    required double halfHeight,
  }) {
    final faces = <_OrderedPrismFace>[];

    for (final face in [
      _PrismFacePlacement(
        label: 'stern',
        center: vm.Vector3(0.0, 0.0, halfDepth),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, 0.0, halfDepth, 1.0)
          ..rotateY(pi),
      ),
      _PrismFacePlacement(
        label: 'keel',
        center: vm.Vector3(0.0, halfHeight, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, halfHeight, 0.0, 1.0)
          ..rotateX(pi / 2),
      ),
      _PrismFacePlacement(
        label: 'starboard',
        center: vm.Vector3(-halfWidth, 0.0, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(-halfWidth, 0.0, 0.0, 1.0)
          ..rotateY(pi / 2),
      ),
      _PrismFacePlacement(
        label: 'port',
        center: vm.Vector3(halfWidth, 0.0, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(halfWidth, 0.0, 0.0, 1.0)
          ..rotateY(-pi / 2),
      ),
      _PrismFacePlacement(
        label: 'deck',
        center: vm.Vector3(0.0, -halfHeight, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, -halfHeight, 0.0, 1.0)
          ..rotateX(-pi / 2),
      ),
      _PrismFacePlacement(
        label: 'stem',
        center: vm.Vector3(0.0, 0.0, -halfDepth),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, 0.0, -halfDepth, 1.0),
      ),
    ]) {
      final rotatedCenter = rotation.transform3(vm.Vector3.copy(face.center));
      faces.add(
        _OrderedPrismFace(
          depth: rotatedCenter.z,
          transform: face.transform,
          child: _buildFace(image, face.label),
        ),
      );
    }

    faces.sort((a, b) => b.depth.compareTo(a.depth));
    return faces;
  }

  Widget _buildFace(ui.Image image, String label) {
    final crop = widget.prismFaceValues[label];
    assert(crop != null, 'Missing face values for "$label".');
    final size = switch (label) {
      'deck' || 'keel' => widget.dimensions.topFaceSize,
      _ => widget.dimensions.sideFaceSize,
    };

    return _PrismFace(
      image: image,
      spec: _PrismFaceSpec(label: label, size: size, crop: crop!),
    );
  }
}

class _PrismFacePlacement {
  const _PrismFacePlacement({
    required this.label,
    required this.center,
    required this.transform,
  });

  final String label;
  final vm.Vector3 center;
  final Matrix4 transform;
}

class _OrderedPrismFace {
  const _OrderedPrismFace({
    required this.depth,
    required this.transform,
    required this.child,
  });

  final double depth;
  final Matrix4 transform;
  final Widget child;
}

class _PrismFaceSpec {
  const _PrismFaceSpec({
    required this.label,
    required this.size,
    required this.crop,
  });

  final String label;
  final Size size;
  final Rect crop;
}

class _PrismFace extends StatelessWidget {
  const _PrismFace({required this.image, required this.spec});

  final ui.Image image;
  final _PrismFaceSpec spec;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: spec.size.width,
      height: spec.size.height,
      child: ClipRect(
        child: CustomPaint(
          size: spec.size,
          painter: _PrismFacePainter(image: image, crop: spec.crop),
        ),
      ),
    );
  }
}

class _PrismFacePainter extends CustomPainter {
  const _PrismFacePainter({required this.image, required this.crop});

  final ui.Image image;
  final Rect crop;

  @override
  void paint(Canvas canvas, Size size) {
    final sourceRect = Rect.fromLTWH(
      crop.left * image.width,
      crop.top * image.height,
      crop.width * image.width,
      crop.height * image.height,
    );

    canvas.drawImageRect(
      image,
      sourceRect,
      Offset.zero & size,
      Paint()..filterQuality = FilterQuality.high,
    );
  }

  @override
  bool shouldRepaint(covariant _PrismFacePainter oldDelegate) {
    return oldDelegate.image != image || oldDelegate.crop != crop;
  }
}
