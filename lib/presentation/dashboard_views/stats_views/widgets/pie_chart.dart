import 'dart:math';

import 'package:flutter/material.dart';
import 'package:money_manager/domain/value_objects/transaction/value_objects.dart';

class PieChartCase extends StatelessWidget {
  final Map<Category, int> categoryMapping;
  const PieChartCase({required this.categoryMapping, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                spreadRadius: -10,
                blurRadius: 17,
                offset: Offset(-5, -5),
                color: Color.fromRGBO(146, 182, 216, 1),
              ),
              BoxShadow(
                spreadRadius: -2,
                blurRadius: 10,
                offset: Offset(7, 7),
                color: Color.fromRGBO(146, 182, 216, 1),
              )
            ],
          ),
          child: Stack(children: [
            Center(
              child: SizedBox(
                width: constraint.maxWidth * 0.4,
                child: CustomPaint(
                  foregroundPainter: PieChart(width: constraint.maxWidth * 0.37, categories: categoryMapping),
                  child: const Center(),
                ),
              ),
            ),
            Center(
              child: Container(
                height: constraint.maxWidth * 0.3,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      spreadRadius: -10,
                      blurRadius: 17,
                      offset: Offset(-5, -5),
                      color: Colors.white,
                    ),
                    BoxShadow(
                      spreadRadius: -2,
                      blurRadius: 10,
                      offset: Offset(7, 7),
                      color: Color.fromRGBO(146, 182, 216, 1),
                    )
                  ],
                ),
                child: const Center(
                  child: Text("Rs 1000"),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}

class PieChart extends CustomPainter {
  final Map<Category, int> categories;
  final double width;

  PieChart({required this.categories, required this.width});
  @override
  void paint(Canvas canvas, Size size) {
    Offset center = Offset(size.width / 2, size.height / 2);
    double radius = min(size.width / 2, size.height / 2);

    var paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = width / 2;

    double total = 0;
    categories.forEach((key, value) {
      total += value.toInt();
    });

    double startRadian = -pi / 2;

    categories.forEach((key, value) {
      final sweepRadian = value / total * 2 * pi;
      paint.color = key.color;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRadian,
        sweepRadian,
        false,
        paint,
      );
      startRadian += sweepRadian;
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
