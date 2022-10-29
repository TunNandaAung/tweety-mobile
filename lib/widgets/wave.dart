import 'package:flutter/material.dart';
import 'dart:math' as math;

class Wave extends StatefulWidget {
  final Size size;
  final double yOffset;
  final Color color;

  const Wave({
    super.key,
    required this.size,
    required this.yOffset,
    required this.color,
  });

  @override
  WaveState createState() => WaveState();
}

class WaveState extends State<Wave> with TickerProviderStateMixin {
  late AnimationController animationController;
  List<Offset> wavePoints = [];

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 5000))
      ..addListener(() {
        wavePoints.clear();

        final double waveSpeed = animationController.value * 1080;
        final double fullSphere = animationController.value * math.pi * 2;
        final double normalizer = math.cos(fullSphere);
        const double waveWidth = math.pi / 270;
        const double waveHeight = 20.0;

        for (int i = 0; i <= widget.size.width.toInt(); ++i) {
          double calc = math.sin((waveSpeed - i) * waveWidth);
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
  ClipperWidget({required this.waveList});

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
