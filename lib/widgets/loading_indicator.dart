import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final size;

  const LoadingIndicator({Key key, this.size = 30.0}) : super(key: key);

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
