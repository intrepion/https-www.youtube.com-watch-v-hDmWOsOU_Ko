import 'package:flutter/material.dart';

import '../prism_config.dart';
import 'asset_ui_image_loader.dart';
import 'prism_renderer.dart';

class RectangularPrism extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AssetUiImageLoader(
      assetPath: imageAssetPath,
      builder: (context, prismImage) {
        if (prismImage == null) {
          return SizedBox(
            width: dimensions.width.toDouble(),
            height: dimensions.height.toDouble(),
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        final prismRotation = Matrix4.identity()
          ..rotateX(rx)
          ..rotateY(ry)
          ..rotateZ(rz);
        final prismTransform = Matrix4.identity()
          ..setEntry(3, 2, prismPerspectiveStrength)
          ..multiply(prismRotation)
          ..scaleByDouble(zoom, zoom, zoom, 1.0);
        final renderer = PrismRenderer(
          image: prismImage,
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
      },
    );
  }
}
