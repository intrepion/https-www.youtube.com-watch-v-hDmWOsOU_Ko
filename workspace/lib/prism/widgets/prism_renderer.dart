import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../prism_config.dart';
import 'prism_face.dart';

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
    final halfWidth = dimensions.topFaceSize.width / 2;
    final halfDepth = dimensions.topFaceSize.height / 2;
    final halfHeight = dimensions.sideFaceSize.height / 2;
    final faces = <OrderedPrismFace>[];

    for (final face in [
      _PrismFacePlacement(
        label: 'stern',
        center: vm.Vector3(0.0, 0.0, halfDepth),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, 0.0, halfDepth, 1.0)
          ..rotateY(pi),
      ),
      _PrismFacePlacement(
        label: 'keel',
        center: vm.Vector3(0.0, halfHeight, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, halfHeight, 0.0, 1.0)
          ..rotateX(pi / 2),
      ),
      _PrismFacePlacement(
        label: 'starboard',
        center: vm.Vector3(-halfWidth, 0.0, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(-halfWidth, 0.0, 0.0, 1.0)
          ..rotateY(pi / 2),
      ),
      _PrismFacePlacement(
        label: 'port',
        center: vm.Vector3(halfWidth, 0.0, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(halfWidth, 0.0, 0.0, 1.0)
          ..rotateY(-pi / 2),
      ),
      _PrismFacePlacement(
        label: 'deck',
        center: vm.Vector3(0.0, -halfHeight, 0.0),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, -halfHeight, 0.0, 1.0)
          ..rotateX(-pi / 2),
      ),
      _PrismFacePlacement(
        label: 'stem',
        center: vm.Vector3(0.0, 0.0, -halfDepth),
        transform: Matrix4.identity()
          ..translateByDouble(0.0, 0.0, -halfDepth, 1.0),
      ),
    ]) {
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

class _PrismFacePlacement {
  const _PrismFacePlacement({
    required this.label,
    required this.center,
    required this.transform,
  });

  final String label;
  final vm.Vector3 center;
  final Matrix4 transform;
}
