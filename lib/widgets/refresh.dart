import 'package:flutter/material.dart';

class Refresh extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const Refresh({Key key, this.title, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(color: Colors.red),
        ),
        SizedBox(height: 5.0),
        RawMaterialButton(
          padding: EdgeInsets.all(15.0),
          shape: CircleBorder(),
          elevation: 2.0,
          fillColor: Color(0xFF4A5568),
          child: Icon(Icons.refresh, color: Colors.white, size: 20.0),
          onPressed: onPressed,
        ),
      ],
    ));
  }
}
