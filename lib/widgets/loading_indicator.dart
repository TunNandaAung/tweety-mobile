import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final size;
  final strokeWidth;

  const LoadingIndicator({Key key, this.size = 30.0, this.strokeWidth = 1.5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(
        Theme.of(context).primaryColor,
      ),
    ));
  }
}
