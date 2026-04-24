import 'dart:math';

import 'package:flutter/material.dart';

const prismMinZoom = 0.4;
const prismMaxZoom = 2.5;

class PrismViewState {
  double rx = 0.0;
  double ry = 0.0;
  double rz = 0.0;
  double zoom = 1.0;

  bool setRx(double value) {
    if (rx == value) return false;
    rx = value;
    return true;
  }

  bool setRy(double value) {
    if (ry == value) return false;
    ry = value;
    return true;
  }

  bool setRz(double value) {
    if (rz == value) return false;
    rz = value;
    return true;
  }

  bool setZoom(double value) {
    final nextZoom = value.clamp(prismMinZoom, prismMaxZoom);
    if (zoom == nextZoom) return false;
    zoom = nextZoom;
    return true;
  }

  bool rotateByDrag(DragUpdateDetails details) {
    return rotateByDelta(details.delta);
  }

  bool rotateByDelta(Offset delta) {
    final nextRx = (rx + delta.dy * 0.01) % (pi * 2);
    final nextRy = (ry - delta.dx * 0.01) % (pi * 2);
    if (rx == nextRx && ry == nextRy) return false;
    rx = nextRx;
    ry = nextRy;
    return true;
  }
}
