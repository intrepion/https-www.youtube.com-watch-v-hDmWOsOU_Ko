import 'package:flutter/material.dart';

enum PrismFaceId {
  starboard('starboard', 'Starboard'),
  stem('stem', 'Stem'),
  port('port', 'Port'),
  stern('stern', 'Stern'),
  deck('deck', 'Deck'),
  keel('keel', 'Keel');

  const PrismFaceId(this.key, this.label);

  final String key;
  final String label;

  bool get isTopOrBottom => this == PrismFaceId.deck || this == PrismFaceId.keel;

  static PrismFaceId? tryParse(String key) {
    for (final faceId in PrismFaceId.values) {
      if (faceId.key == key) return faceId;
    }
    return null;
  }
}

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrismDimensions &&
        other.width == width &&
        other.depth == depth &&
        other.height == height;
  }

  @override
  int get hashCode => Object.hash(width, depth, height);

  @override
  String toString() => 'PrismDimensions($key)';
}

class PrismImageOption {
  PrismImageOption({
    required this.assetPath,
    required this.dimensions,
    required this.name,
    required this.extension,
  });

  factory PrismImageOption.fromAssetPath(String assetPath) {
    final match = RegExp(
      r'^assets/scentsy-box-(\d+)x(\d+)x(\d+)-(.+)\.([A-Za-z0-9]+)$',
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
    final extension = match.group(5)!;

    return PrismImageOption(
      assetPath: assetPath,
      dimensions: PrismDimensions(width: width, depth: depth, height: height),
      name: rawName,
      extension: extension,
    );
  }

  final String assetPath;
  final PrismDimensions dimensions;
  final String name;
  final String extension;

  String get label => '${_titleCaseWords(name)} (${dimensions.key})';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrismImageOption &&
        other.assetPath == assetPath &&
        other.dimensions == dimensions &&
        other.name == name &&
        other.extension == extension;
  }

  @override
  int get hashCode => Object.hash(assetPath, dimensions, name, extension);

  @override
  String toString() => 'PrismImageOption($assetPath)';
}

String _titleCaseWords(String value) {
  return value
      .split('-')
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
