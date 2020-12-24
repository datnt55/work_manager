import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ArrowPainter extends CustomPainter {
  final lineWidth;

  ArrowPainter(this.lineWidth);

  @override
  void paint(Canvas canvas, Size size) {
    Path path;

    // The arrows usually looks better with rounded caps.
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 3.0;

    final rectangeWidth = lineWidth/10.0;
    /// Draw a single arrow.
    path = Path();
    path.moveTo(0.5, 0.5);
    path.lineTo(rectangeWidth, rectangeWidth);
    path.lineTo(0.5, rectangeWidth*2);
    path.close();

    canvas.drawPath(path, paint);

    paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset(0.5, rectangeWidth), Offset(lineWidth - 0.5,rectangeWidth), paint);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => true;
}