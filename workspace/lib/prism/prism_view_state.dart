import 'dart:math';

import 'package:flutter/material.dart';

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
    if (zoom == value) return false;
    zoom = value;
    return true;
  }

  bool rotateByDrag(DragUpdateDetails details) {
    final nextRx = (rx + details.delta.dy * 0.01) % (pi * 2);
    final nextRy = (ry - details.delta.dx * 0.01) % (pi * 2);
    if (rx == nextRx && ry == nextRy) return false;
    rx = nextRx;
    ry = nextRy;
    return true;
  }
}
