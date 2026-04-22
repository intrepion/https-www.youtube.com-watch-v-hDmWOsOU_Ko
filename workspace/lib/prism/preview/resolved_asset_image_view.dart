import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'asset_load_placeholder.dart';
import 'asset_ui_image_loader.dart';

class ResolvedAssetImageView extends StatelessWidget {
  const ResolvedAssetImageView({
    super.key,
    required this.assetPath,
    required this.loadingWidth,
    required this.loadingHeight,
    required this.errorWidth,
    required this.errorHeight,
    required this.builder,
  });

  final String assetPath;
  final double loadingWidth;
  final double loadingHeight;
  final double errorWidth;
  final double errorHeight;
  final Widget Function(BuildContext context, ui.Image image) builder;

  @override
  Widget build(BuildContext context) {
    return AssetUiImageLoader(
      assetPath: assetPath,
      builder: (context, loadState) {
        if (loadState.hasError) {
          return AssetLoadPlaceholder.error(
            width: errorWidth,
            height: errorHeight,
          );
        }

        final image = loadState.image;
        if (loadState.isLoading || image == null) {
          return AssetLoadPlaceholder.loading(
            width: loadingWidth,
            height: loadingHeight,
          );
        }

        return builder(context, image);
      },
    );
  }
}
