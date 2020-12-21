import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path;

    // The arrows usually looks better with rounded caps.
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 3.0;

    /// Draw a single arrow.
    path = Path();
    path.moveTo(0, 0);
    path.lineTo(5, 5);
    path.lineTo(0, 10);
    path.close();

    canvas.drawPath(path, paint);

    paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0, 5), Offset(55,5), paint);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => false;
}