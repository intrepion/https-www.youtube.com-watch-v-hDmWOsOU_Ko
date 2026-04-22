import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../model/prism_models.dart';

class PrismFacePlacement {
  const PrismFacePlacement({
    required this.faceId,
    required this.center,
    required this.transform,
  });

  final PrismFaceId faceId;
  final vm.Vector3 center;
  final Matrix4 transform;
}

List<PrismFacePlacement> buildPrismFacePlacements(PrismDimensions dimensions) {
  final halfWidth = dimensions.topFaceSize.width / 2;
  final halfDepth = dimensions.topFaceSize.height / 2;
  final halfHeight = dimensions.sideFaceSize.height / 2;

  return [
    PrismFacePlacement(
      faceId: PrismFaceId.stern,
      center: vm.Vector3(0.0, 0.0, halfDepth),
      transform: Matrix4.identity()
        ..translateByDouble(0.0, 0.0, halfDepth, 1.0)
        ..rotateY(pi),
    ),
    PrismFacePlacement(
      faceId: PrismFaceId.keel,
      center: vm.Vector3(0.0, halfHeight, 0.0),
      transform: Matrix4.identity()
        ..translateByDouble(0.0, halfHeight, 0.0, 1.0)
        ..rotateX(pi / 2),
    ),
    PrismFacePlacement(
      faceId: PrismFaceId.starboard,
      center: vm.Vector3(-halfWidth, 0.0, 0.0),
      transform: Matrix4.identity()
        ..translateByDouble(-halfWidth, 0.0, 0.0, 1.0)
        ..rotateY(pi / 2),
    ),
    PrismFacePlacement(
      faceId: PrismFaceId.port,
      center: vm.Vector3(halfWidth, 0.0, 0.0),
      transform: Matrix4.identity()
        ..translateByDouble(halfWidth, 0.0, 0.0, 1.0)
        ..rotateY(-pi / 2),
    ),
    PrismFacePlacement(
      faceId: PrismFaceId.deck,
      center: vm.Vector3(0.0, -halfHeight, 0.0),
      transform: Matrix4.identity()
        ..translateByDouble(0.0, -halfHeight, 0.0, 1.0)
        ..rotateX(-pi / 2),
    ),
    PrismFacePlacement(
      faceId: PrismFaceId.stem,
      center: vm.Vector3(0.0, 0.0, -halfDepth),
      transform: Matrix4.identity()
        ..translateByDouble(0.0, 0.0, -halfDepth, 1.0),
    ),
  ];
}
