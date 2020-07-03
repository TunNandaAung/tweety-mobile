import 'package:flutter/material.dart';
import 'dart:math' as Math;

class Wave extends StatefulWidget {
  final Size size;
  final double yOffset;
  final Color color;

  Wave({
    this.size,
    this.yOffset,
    this.color,
  });

  @override
  _WaveState createState() => _WaveState();
}

class _WaveState extends State<Wave> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> wavePoints = [];

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 5000))
          ..addListener(() {
            wavePoints.clear();

            final double waveSpeed = animationController.value * 1080;
            final double fullSphere = animationController.value * Math.pi * 2;
            final double normalizer = Math.cos(fullSphere);
            final double waveWidth = Math.pi / 270;
            final double waveHeight = 20.0;

            for (int i = 0; i <= widget.size.width.toInt(); ++i) {
              double calc = Math.sin((waveSpeed - i) * waveWidth);
              wavePoints.add(
                Offset(
                  i.toDouble(), //X
                  calc * waveHeight * normalizer + widget.yOffset, //Y
                ),
              );
            }
          });

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, _) {
        return ClipPath(
          clipper: ClipperWidget(
            waveList: wavePoints,
          ),
          child: Container(
            width: widget.size.width,
            height: widget.size.height,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class ClipperWidget extends CustomClipper<Path> {
  final List<Offset> waveList;
  ClipperWidget({this.waveList});

  @override
  getClip(Size size) {
    final Path path = Path();
    path.addPolygon(waveList, false);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
