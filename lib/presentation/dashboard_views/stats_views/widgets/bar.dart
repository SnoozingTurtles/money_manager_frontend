import 'package:flutter/material.dart';

class Bar extends StatelessWidget {
  const Bar({
    super.key,
    required this.width,
    required this.height,
    required this.value,
    required this.color,
  });

  final num width;
  final num height;

  /// Value from 1.0 to 0.0
  final num value;

  final Color color;

  @override
  Widget build(BuildContext context) {
    final innerContainerWidth = value;
    final innerContainerHeight = height;
    return Column(
      children: <Widget>[
        SizedBox(
          height: height * 1.01,
          width: width * 1,
          child: Stack(
            children: <Widget>[
              DugContainer(
                width: width,
                height: height,
              ),
              InnerContainer(width: innerContainerWidth, height: innerContainerHeight, color: color),
            ],
          ),
        ),
      ],
    );
  }
}

class InnerContainer extends StatelessWidget {
  const InnerContainer({
    super.key,
    required this.height,
    required this.width,
    required this.color,
  });

  final num height;
  final num width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            height: height * 600 / 896,
            width: width * 1, //dynamic update
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(95.0),
              color: color,
              boxShadow: [
                const BoxShadow(
                  offset: Offset(1.5, 1.5),
                  color: Colors.black38,
                  blurRadius: 2,
                ),
                BoxShadow(
                  offset: const Offset(-1.5, -1.5),
                  color: color,
                  blurRadius: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DugContainer extends StatelessWidget {
  const DugContainer({
    super.key,
    required this.height,
    required this.width,
  });
  final num height;
  final num width;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: height * 600 / 896,
        width: width * 1,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: exteriorShadow,
              offset: Offset(0.0, 0.0),
            ),
            BoxShadow(
              color: interiorShadow,
              offset: Offset(0.0, 0.0),
              spreadRadius: -1.0,
              blurRadius: 11.0,
            ),
          ],
          borderRadius: BorderRadius.circular(100.0),
        ),
      ),
    );
  }
}

const exteriorShadow = Color.fromRGBO(209, 207, 205, 1);
const interiorShadow = Color.fromRGBO(224, 221, 217, 1);
const backgroundColor = Color.fromRGBO(235, 235, 234, 1);
