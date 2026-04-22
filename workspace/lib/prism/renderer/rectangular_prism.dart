import 'package:flutter/material.dart';

import '../config/prism_constants.dart';
import '../preview/asset_load_placeholder.dart';
import '../model/prism_models.dart';
import '../preview/asset_ui_image_loader.dart';
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
    return AssetUiImageLoader(
      assetPath: imageOption.assetPath,
      builder: (context, loadState) {
        if (loadState.hasError) {
          return AssetLoadPlaceholder.error(
            width: dimensions.width.toDouble(),
            height: dimensions.height.toDouble(),
          );
        }

        final prismImage = loadState.image;
        if (loadState.isLoading || prismImage == null) {
          return AssetLoadPlaceholder.loading(
            width: dimensions.width.toDouble(),
            height: dimensions.height.toDouble(),
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
