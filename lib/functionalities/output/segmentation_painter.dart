/*import 'package:flutter/material.dart';
import 'package:nutripro/model/segmentation/segmentation.dart';

class SegmentationPainter extends CustomPainter {
  final Segmentation segmentation;

  SegmentationPainter(this.segmentation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red.withOpacity(0.2) // Adjusted for more transparency
      ..style = PaintingStyle.fill;

    // Draw polygons for the segmentation
    for (var polygon in segmentation.polygons) {
      Path path = Path();

      // Convert map coordinates to Offset for the path
      if (polygon.isNotEmpty) {
        // Start at the first point
        path.moveTo(polygon.values.firstWhere((v) => v.isFinite), polygon.values.elementAt(1));

        for (var entry in polygon.entries) {
          path.lineTo(entry.value, polygon[entry.key]!);
        }
        path.close();
      }

      // Draw the path on the canvas
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SegmentationPainter oldDelegate) => false;
}*/
