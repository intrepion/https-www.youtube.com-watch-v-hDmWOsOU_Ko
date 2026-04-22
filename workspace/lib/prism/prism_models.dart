import 'package:flutter/material.dart';

class PrismDimensions {
  const PrismDimensions({
    required this.width,
    required this.depth,
    required this.height,
  });

  final int width;
  final int depth;
  final int height;

  String get key => '${width}x${depth}x$height';
  Size get topFaceSize => Size(width.toDouble(), depth.toDouble());
  Size get sideFaceSize => Size(width.toDouble(), height.toDouble());
}

class PrismImageOption {
  PrismImageOption({
    required this.assetPath,
    required this.dimensions,
    required this.name,
  });

  factory PrismImageOption.fromAssetPath(String assetPath) {
    final match = RegExp(
      r'^assets/scentsy-box-(\d+)x(\d+)x(\d+)-(.+)\.png$',
    ).firstMatch(assetPath);
    if (match == null) {
      throw ArgumentError.value(
        assetPath,
        'assetPath',
        'Unexpected asset name',
      );
    }

    final width = int.parse(match.group(1)!);
    final depth = int.parse(match.group(2)!);
    final height = int.parse(match.group(3)!);
    final rawName = match.group(4)!;

    return PrismImageOption(
      assetPath: assetPath,
      dimensions: PrismDimensions(width: width, depth: depth, height: height),
      name: rawName,
    );
  }

  final String assetPath;
  final PrismDimensions dimensions;
  final String name;

  String get label => '${_titleCaseWords(name)} (${dimensions.key})';
}

String _titleCaseWords(String value) {
  return value
      .split('-')
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
