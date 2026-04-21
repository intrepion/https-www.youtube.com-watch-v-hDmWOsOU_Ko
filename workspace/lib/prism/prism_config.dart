import 'package:flutter/material.dart';

const prismImageAssetPaths = <String>[
  'assets/scentsy-box-165x165x178-ewok.png',
  'assets/scentsy-box-165x165x178-elsa.png',
  'assets/scentsy-box-165x165x270-cinderella.png',
  'assets/scentsy-box-165x165x270-santa-stitch.png',
];

const minimumCropExtent = 0.05;
const prismPerspectiveStrength = 0.0025;

const defaultPrismFaceValuesByDimensions = <String, Map<String, Rect>>{
  '165x165x178': {
    'keel': Rect.fromLTWH(0.0336, 0.0800, 0.2235, 0.3100),
    'deck': Rect.fromLTWH(0.2561, 0.0800, 0.2235, 0.3100),
    'starboard': Rect.fromLTWH(0.0336, 0.4100, 0.2235, 0.3300),
    'stem': Rect.fromLTWH(0.2561, 0.4100, 0.2235, 0.3300),
    'port': Rect.fromLTWH(0.4796, 0.4100, 0.2235, 0.3300),
    'stern': Rect.fromLTWH(0.7027, 0.4100, 0.2235, 0.3300),
  },
  '165x165x270': {
    'keel': Rect.fromLTWH(0.0065, 0.0641, 0.2369, 0.2730),
    'deck': Rect.fromLTWH(0.2436, 0.0641, 0.2369, 0.2730),
    'starboard': Rect.fromLTWH(0.0065, 0.3386, 0.2369, 0.4642),
    'stem': Rect.fromLTWH(0.2436, 0.3386, 0.2369, 0.4642),
    'port': Rect.fromLTWH(0.4824, 0.3386, 0.2369, 0.4642),
    'stern': Rect.fromLTWH(0.7195, 0.3386, 0.2369, 0.4642),
  },
};

const prismFaceDropdownLabels = <String, String>{
  'starboard': 'Starboard',
  'stem': 'Stem',
  'port': 'Port',
  'stern': 'Stern',
  'deck': 'Deck',
  'keel': 'Keel',
};

const prismFaceOverlayColors = <String, Color>{
  'starboard': Color(0xFF1565C0),
  'stem': Color(0xFF2E7D32),
  'port': Color(0xFFAD1457),
  'stern': Color(0xFF6A1B9A),
  'deck': Color(0xFFEF6C00),
  'keel': Color(0xFF00838F),
};

final prismImageOptions = prismImageAssetPaths
    .map(PrismImageOption.fromAssetPath)
    .toList(growable: false);

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
