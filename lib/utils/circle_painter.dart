import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {

 double dia;
 Color color;

 CirclePainter(this.dia,this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = this.color
      ..strokeWidth = 15;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, this.dia, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}