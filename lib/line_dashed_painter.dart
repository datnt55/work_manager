import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LineDashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1
      ..strokeJoin = StrokeJoin.round;
    var max = 106;
    var dashWidth = 1;
    var dashSpace = 1;
    double startX = 0;
    while (max >= 0) {
      canvas.drawCircle(Offset(startX,0), 0.45, paint);
      final space = (dashSpace + dashWidth);
      startX += space;
      max -= space;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}