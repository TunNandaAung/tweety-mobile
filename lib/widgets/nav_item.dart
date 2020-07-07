import 'package:flutter/material.dart';

Widget navigationItem(context,
    {Color boxColor,
    String title,
    TextStyle textStyle,
    IconData icon,
    Color iconColor,
    VoidCallback onTap}) {
  return Container(
    decoration: BoxDecoration(
      color: boxColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      title: Text(title,
          style: textStyle ?? TextStyle(fontWeight: FontWeight.w600)),
      trailing: Icon(
        icon,
        color: iconColor,
      ),
      onTap: onTap,
    ),
  );
}
