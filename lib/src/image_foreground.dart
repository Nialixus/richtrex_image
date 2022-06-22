import 'package:flutter/material.dart';

export 'image_foreground.dart' hide ImageForeground;

class ImageForeground extends CustomPainter {
  const ImageForeground(
      {this.color = Colors.black,
      this.size = const Size(12.5, 12.5),
      this.backgroundColor = Colors.white});

  /// Border color, by default is `0xff000000`.
  final Color color;

  /// Background color of Box, by default is `0xffffffff`.
  final Color backgroundColor;

  /// Box Size, by default is `10 x 10`.
  final Size size;

  @override
  void paint(Canvas canvas, Size size) {
    Path rectangle = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    Paint border = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    Paint background = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    Path box(double x, double y) => Path()
      ..moveTo(x - this.size.width / 2, y - this.size.height / 2)
      ..lineTo(x + this.size.width / 2, y - this.size.height / 2)
      ..lineTo(x + this.size.width / 2, y + this.size.height / 2)
      ..lineTo(x - this.size.width / 2, y + this.size.height / 2)
      ..close();

    List<Size> boxPosition = [
      const Size(0, 0),
      Size(size.width, 0),
      Size(size.width, size.height),
      Size(0, size.height),
    ];

    canvas.drawPath(rectangle, border);

    for (var value in boxPosition) {
      canvas.drawPath(box(value.width, value.height), background);
      canvas.drawPath(box(value.width, value.height), border);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate != this;
}
