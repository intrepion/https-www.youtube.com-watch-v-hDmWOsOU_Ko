import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class AssetUiImageLoadState {
  const AssetUiImageLoadState({
    required this.image,
    required this.error,
    required this.stackTrace,
  });

  final ui.Image? image;
  final Object? error;
  final StackTrace? stackTrace;

  bool get isLoading => image == null && error == null;
  bool get hasError => error != null;
}

class AssetUiImageLoader extends StatefulWidget {
  const AssetUiImageLoader({
    super.key,
    required this.assetPath,
    required this.builder,
  });

  final String assetPath;
  final Widget Function(BuildContext context, AssetUiImageLoadState state)
  builder;

  @override
  State<AssetUiImageLoader> createState() => _AssetUiImageLoaderState();
}

class _AssetUiImageLoaderState extends State<AssetUiImageLoader> {
  ui.Image? _image;
  Object? _error;
  StackTrace? _stackTrace;
  ImageStream? _imageStream;
  late final ImageStreamListener _imageListener = ImageStreamListener(
    (imageInfo, _) {
      if (!mounted) return;
      setState(() {
        _image = imageInfo.image;
        _error = null;
        _stackTrace = null;
      });
    },
    onError: (exception, stackTrace) {
      if (!mounted) return;
      setState(() {
        _image = null;
        _error = exception;
        _stackTrace = stackTrace;
      });
    },
  );

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
    _image = null;
    _error = null;
    _stackTrace = null;
    _imageStream = stream..addListener(_imageListener);
  }

  @override
  void dispose() {
    _imageStream?.removeListener(_imageListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      AssetUiImageLoadState(
        image: _image,
        error: _error,
        stackTrace: _stackTrace,
      ),
    );
  }
}
