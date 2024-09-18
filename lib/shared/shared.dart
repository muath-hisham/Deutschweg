import 'package:flutter/material.dart';
import 'package:menschen/shared/dimensions.dart';

Color mainColor = Color(0xFF1eb5d0);
Color headTextColor = Colors.white;
Color secondTextColor = Colors.black;
Color tabControllerColor = mainColor;

Color derColor = Colors.blue;
Color dieColor = Colors.redAccent;
Color dasColor = Colors.green;

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;

    double gap = size.height / 3; // Adjust gap between lines

    for (int i = 1; i <= 4; i++) {
      canvas.drawLine(
        Offset(-Dimensions.getScreenWidth, i * gap),
        Offset(Dimensions.getScreenWidth, i * gap),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
