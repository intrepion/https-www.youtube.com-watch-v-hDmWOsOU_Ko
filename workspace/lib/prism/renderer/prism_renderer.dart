import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../prism_config.dart';
import 'prism_face.dart';
import 'prism_face_placements.dart';

class OrderedPrismFace {
  const OrderedPrismFace({
    required this.depth,
    required this.transform,
    required this.child,
  });

  final double depth;
  final Matrix4 transform;
  final Widget child;
}

class PrismRenderer {
  const PrismRenderer({
    required this.image,
    required this.dimensions,
    required this.prismFaceValues,
  });

  final ui.Image image;
  final PrismDimensions dimensions;
  final Map<String, Rect> prismFaceValues;

  List<OrderedPrismFace> orderedFaces(Matrix4 rotation) {
    final faces = <OrderedPrismFace>[];

    for (final face in buildPrismFacePlacements(dimensions)) {
      final rotatedCenter = rotation.transform3(vm.Vector3.copy(face.center));
      faces.add(
        OrderedPrismFace(
          depth: rotatedCenter.z,
          transform: face.transform,
          child: _buildFace(face.label),
        ),
      );
    }

    faces.sort((a, b) => b.depth.compareTo(a.depth));
    return faces;
  }

  Widget _buildFace(String label) {
    final crop = prismFaceValues[label];
    assert(crop != null, 'Missing face values for "$label".');
    final size = switch (label) {
      'deck' || 'keel' => dimensions.topFaceSize,
      _ => dimensions.sideFaceSize,
    };

    return PrismFace(
      image: image,
      spec: PrismFaceSpec(label: label, size: size, crop: crop!),
    );
  }
}
