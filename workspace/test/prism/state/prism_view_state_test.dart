import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hello_world/prism/state/prism_view_state.dart';

void main() {
  test('rotateByDrag updates rx and ry using drag direction', () {
    final state = PrismViewState();

    final changed = state.rotateByDrag(
      DragUpdateDetails(globalPosition: Offset.zero, delta: Offset(10, 20)),
    );

    expect(changed, isTrue);
    expect(state.rx, closeTo(0.2, 0.0001));
    expect(state.ry, closeTo((pi * 2) - 0.1, 0.0001));
  });

  test('setters report false when value is unchanged', () {
    final state = PrismViewState();

    expect(state.setRx(0.0), isFalse);
    expect(state.setRy(0.0), isFalse);
    expect(state.setRz(0.0), isFalse);
    expect(state.setZoom(1.0), isFalse);
  });
}
