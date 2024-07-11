import 'package:canvas_drawing/model/sketch.dart';
import 'package:flutter/material.dart';

class DrawingBorard extends StatefulWidget {
  const DrawingBorard({super.key});

  @override
  State<DrawingBorard> createState() => _DrawingBorardState();
}

class _DrawingBorardState extends State<DrawingBorard> {
  List<DrawPoint> drawingPoints = [];
  DrawPoint? currentDrawPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            currentDrawPoint = DrawPoint(
              points: [details.localPosition],
              id: DateTime.now().microsecondsSinceEpoch,
            );
            if (currentDrawPoint == null) return;
            drawingPoints.add(currentDrawPoint!);
          });
        },
        onPanUpdate: (details) {
          setState(() {
            if (currentDrawPoint == null) return;
            currentDrawPoint = currentDrawPoint?.copyWith(
              points: currentDrawPoint?.points?..add(details.localPosition),
            );
            drawingPoints.last = currentDrawPoint!;
          });
        },
        onPanEnd: (details) {
          setState(() {
            currentDrawPoint = null;
          });
        },
        child: CustomPaint(
          painter: DrawingBoardPainter(drawingPoints),
          size: MediaQuery.of(context).size,
        ),
      ),
    );
  }
}

class DrawingBoardPainter extends CustomPainter {
  DrawingBoardPainter(this.drawingPoints);
  final List<DrawPoint> drawingPoints;

  @override
  void paint(Canvas canvas, Size size) {
    for (DrawPoint drawPoint in drawingPoints) {
      final points = drawPoint.points;
      final Paint paint = Paint()
        ..color = drawPoint.color
        ..strokeWidth = drawPoint.size
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(points.first.dx, points.first.dy);
      if (points.length == 1) {
        path.addOval(Rect.fromCircle(center: points.first, radius: 1));
      }

      for (var i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        path.quadraticBezierTo(
            p0.dx, p0.dy, (p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
