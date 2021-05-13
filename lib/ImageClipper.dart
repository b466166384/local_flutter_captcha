import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// 图片裁剪
class ImageClipper extends CustomPainter {
  final ui.Image image;
   double left;
   double top;
   double right;
   double bottom;

  ImageClipper(this.image,{this.left ,this.top ,this.right,this.bottom });
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
//    print(image.width * left);
//    print(image.height * top);
//    print(image.width * right);
//    print(image.height * bottom);
    Paint paint = Paint();
    canvas.drawImageRect(
        image,
        Rect.fromLTRB(left,  top,
            right,  bottom),
        Rect.fromLTWH(0, 0, size.width, size.height),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}