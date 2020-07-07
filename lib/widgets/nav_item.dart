import 'package:flutter/material.dart';

Widget navigationItem(context,
    {Color boxColor,
    String title,
    TextStyle textStyle,
    IconData icon,
    Color iconColor,
    VoidCallback onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: boxColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      // child: ListTile(
      //   title: Text(title,
      //       style: textStyle ?? TextStyle(fontWeight: FontWeight.w600)),
      //   trailing: Icon(
      //     icon,
      //     color: iconColor,
      //   ),
      //   onTap: onTap,
      // ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Icon(icon, color: iconColor, size: 30.0),
            SizedBox(width: 20.0),
            Text(
              title,
              style:
                  Theme.of(context).textTheme.caption.copyWith(fontSize: 18.0),
            )
          ],
        ),
      ),
    ),
  );
}
