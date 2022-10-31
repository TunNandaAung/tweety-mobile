import 'package:flutter/material.dart';

class Refresh extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const Refresh({Key? key, required this.title, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(color: Colors.red),
        ),
        const SizedBox(height: 5.0),
        RawMaterialButton(
          padding: const EdgeInsets.all(15.0),
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: const Color(0xFF4A5568),
          onPressed: onPressed,
          child: const Icon(Icons.refresh, color: Colors.white, size: 20.0),
        ),
      ],
    ));
  }
}
