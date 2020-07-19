import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final size;
  final strokeWidth;
  final Color color;

  const LoadingIndicator(
      {Key key, this.size = 30.0, this.strokeWidth = 1.5, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: new AlwaysStoppedAnimation<Color>(
          color ?? Theme.of(context).primaryColor,
        ),
      ),
    ));
  }
}
