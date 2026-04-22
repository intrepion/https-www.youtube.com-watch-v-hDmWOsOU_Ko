import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../prism_config.dart';

class PrismFacePlacement {
  const PrismFacePlacement({
    required this.label,
    required this.center,
    required this.transform,
  });

  final String label;
  final vm.Vector3 center;
  final Matrix4 transform;
}

List<PrismFacePlacement> buildPrismFacePlacements(PrismDimensions dimensions) {
  final halfWidth = dimensions.topFaceSize.width / 2;
  final halfDepth = dimensions.topFaceSize.height / 2;
  final halfHeight = dimensions.sideFaceSize.height / 2;

  return [
    PrismFacePlacement(
      label: 'stern',
      center: vm.Vector3(0.0, 0.0, halfDepth),
      transform: Matrix4.identity()
        ..translateByDouble(0.0, 0.0, halfDepth, 1.0)
        ..rotateY(pi),
    ),
    PrismFacePlacement(
      label: 'keel',
      center: vm.Vector3(0.0, halfHeight, 0.0),
      transform: Matrix4.identity()
        ..translateByDouble(0.0, halfHeight, 0.0, 1.0)
        ..rotateX(pi / 2),
    ),
    PrismFacePlacement(
      label: 'starboard',
      center: vm.Vector3(-halfWidth, 0.0, 0.0),
      transform: Matrix4.identity()
        ..translateByDouble(-halfWidth, 0.0, 0.0, 1.0)
        ..rotateY(pi / 2),
    ),
    PrismFacePlacement(
      label: 'port',
      center: vm.Vector3(halfWidth, 0.0, 0.0),
      transform: Matrix4.identity()
        ..translateByDouble(halfWidth, 0.0, 0.0, 1.0)
        ..rotateY(-pi / 2),
    ),
    PrismFacePlacement(
      label: 'deck',
      center: vm.Vector3(0.0, -halfHeight, 0.0),
      transform: Matrix4.identity()
        ..translateByDouble(0.0, -halfHeight, 0.0, 1.0)
        ..rotateX(-pi / 2),
    ),
    PrismFacePlacement(
      label: 'stem',
      center: vm.Vector3(0.0, 0.0, -halfDepth),
      transform: Matrix4.identity()
        ..translateByDouble(0.0, 0.0, -halfDepth, 1.0),
    ),
  ];
}
