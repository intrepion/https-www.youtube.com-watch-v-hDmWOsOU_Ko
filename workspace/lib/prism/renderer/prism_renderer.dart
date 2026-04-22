import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' as vm;

import '../model/prism_models.dart';
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
  final Map<PrismFaceId, Rect> prismFaceValues;

  List<OrderedPrismFace> orderedFaces(Matrix4 rotation) {
    final faces = <OrderedPrismFace>[];

    for (final face in buildPrismFacePlacements(dimensions)) {
      final rotatedCenter = rotation.transform3(vm.Vector3.copy(face.center));
      faces.add(
        OrderedPrismFace(
          depth: rotatedCenter.z,
          transform: face.transform,
          child: _buildFace(face.faceId),
        ),
      );
    }

    faces.sort((a, b) => b.depth.compareTo(a.depth));
    return faces;
  }

  Widget _buildFace(PrismFaceId faceId) {
    final size = switch (faceId) {
      PrismFaceId.deck || PrismFaceId.keel => dimensions.topFaceSize,
      _ => dimensions.sideFaceSize,
    };
    final crop = prismFaceValues[faceId];

    if (crop == null) {
      return _buildMissingFaceFallback(faceId, size);
    }

    return PrismFace(
      image: image,
      spec: PrismFaceSpec(faceId: faceId, size: size, crop: crop),
    );
  }

  Widget _buildMissingFaceFallback(PrismFaceId faceId, Size size) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: ColoredBox(
        color: Colors.black12,
        child: Center(
          child: Text(
            faceId.label,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
