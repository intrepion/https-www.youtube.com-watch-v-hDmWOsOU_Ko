import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../config/prism_constants.dart';
import '../model/prism_models.dart';
import '../preview/resolved_asset_image_view.dart';
import 'prism_renderer.dart';

class RectangularPrism extends StatelessWidget {
  const RectangularPrism({
    super.key,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.zoom,
    required this.imageOption,
    required this.prismFaceValues,
  });

  final double rx;
  final double ry;
  final double rz;
  final double zoom;
  final PrismImageOption imageOption;
  final Map<PrismFaceId, Rect> prismFaceValues;

  @override
  Widget build(BuildContext context) {
    final dimensions = imageOption.dimensions;
    return ResolvedAssetImageView(
      assetPath: imageOption.assetPath,
      loadingWidth: dimensions.width.toDouble(),
      loadingHeight: dimensions.height.toDouble(),
      errorWidth: dimensions.width.toDouble(),
      errorHeight: dimensions.height.toDouble(),
      builder: (context, prismImage) {
        return ResolvedRectangularPrism(
          image: prismImage,
          dimensions: dimensions,
          prismFaceValues: prismFaceValues,
          rx: rx,
          ry: ry,
          rz: rz,
          zoom: zoom,
        );
      },
    );
  }
}

class ResolvedRectangularPrism extends StatelessWidget {
  const ResolvedRectangularPrism({
    super.key,
    required this.image,
    required this.dimensions,
    required this.prismFaceValues,
    required this.rx,
    required this.ry,
    required this.rz,
    required this.zoom,
  });

  final ui.Image image;
  final PrismDimensions dimensions;
  final Map<PrismFaceId, Rect> prismFaceValues;
  final double rx;
  final double ry;
  final double rz;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    final prismRotation = Matrix4.identity()
      ..rotateX(rx)
      ..rotateY(ry)
      ..rotateZ(rz);
    final prismTransform = Matrix4.identity()
      ..setEntry(3, 2, prismPerspectiveStrength)
      ..multiply(prismRotation)
      ..scaleByDouble(zoom, zoom, zoom, 1.0);
    final renderer = PrismRenderer(
      image: image,
      dimensions: dimensions,
      prismFaceValues: prismFaceValues,
    );
    final orderedFaces = renderer.orderedFaces(prismRotation);

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
}
