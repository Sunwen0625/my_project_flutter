import 'package:flutter/material.dart';

class Detection {
  final String label;
  final double score;
  final double left;
  final double top;
  final double right;
  final double bottom;

  Detection({
    required this.label,
    required this.score,
    required this.left,
    required this.top,
    required this.right,
    required this.bottom,
  });

  Rect toRect(Size size) {
    return Rect.fromLTRB(
      left * size.width,
      top * size.height,
      right * size.width,
      bottom * size.height,
    );
  }

  Rect toNormalizedRect() => Rect.fromLTRB(left, top, right, bottom);
}
