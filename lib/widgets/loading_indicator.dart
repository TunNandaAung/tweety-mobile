import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const LoadingIndicator(
      {Key? key, this.size = 30.0, this.strokeWidth = 1.5, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
      ),
    ));
  }
}
