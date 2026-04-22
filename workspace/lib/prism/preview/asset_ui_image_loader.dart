import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AssetUiImageLoader extends StatefulWidget {
  const AssetUiImageLoader({
    super.key,
    required this.assetPath,
    required this.builder,
  });

  final String assetPath;
  final Widget Function(BuildContext context, ui.Image? image) builder;

  @override
  State<AssetUiImageLoader> createState() => _AssetUiImageLoaderState();
}

class _AssetUiImageLoaderState extends State<AssetUiImageLoader> {
  ui.Image? _image;
  ImageStream? _imageStream;
  late final ImageStreamListener _imageListener = ImageStreamListener((
    imageInfo,
    _,
  ) {
    if (!mounted) return;
    setState(() => _image = imageInfo.image);
  });

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(covariant AssetUiImageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _resolveImage();
    }
  }

  void _resolveImage() {
    final stream = AssetImage(
      widget.assetPath,
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
    return widget.builder(context, _image);
  }
}
