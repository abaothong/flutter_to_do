import 'package:flutter/material.dart';
import 'package:todo/constant/color_constant.dart';

class RadioIcon extends CustomPainter {
  bool isSelected;
  Color outlineColor;
  Color selectedColor;
  RadioIcon(
      this.isSelected, {
        this.outlineColor = Colors.white,
        this.selectedColor = ColorConstant.theme,
      });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(
        Offset(0.0, 0.0),
        8.0,
        Paint()
          ..color = outlineColor
          ..strokeWidth = 2.0
          ..style = PaintingStyle.stroke);
    if (isSelected) {
      canvas.drawCircle(
          Offset(0.0, 0.0),
          5.0,
          Paint()
            ..color = selectedColor
            ..strokeWidth = 2.5
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}