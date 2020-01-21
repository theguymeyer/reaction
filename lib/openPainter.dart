import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chain_reaction/point.dart';

/// Painter class to paint points [Point] in field [FieldWidget]
class OpenPainter extends CustomPainter {

  Paint _paint;
  List<Point> points;

  OpenPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {

    // canvas.save();

    // print("Painting");

    for (var i = 0; i < points.length; i++) {

      _paint = Paint()
        ..style = PaintingStyle.fill
        ..color = points[i].myColor // dedicated color
        ..isAntiAlias = true;

      // (points[i].rad == 40) ? print("Drawing...") : null;
      canvas.drawCircle(points[i].pos, points[i].rad, _paint);
    }

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}