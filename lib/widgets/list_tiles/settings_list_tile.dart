import 'package:flutter/material.dart';
import 'package:tweety_mobile/models/user.dart';

Widget settingsListTile(context, String name,
    {Function onTap, String heroTag, User user}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).canvasColor,
              offset: Offset(0, 10),
              blurRadius: 10,
            )
          ]),
      child: ListTile(
        // leading: icon,
        title: heroTag != null
            ? Hero(
                tag: heroTag,
                child: Text(name, style: Theme.of(context).textTheme.caption),
              )
            : Text(name, style: Theme.of(context).textTheme.caption),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            user != null ? Text(user.email) : Text(''),
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).textSelectionTheme.cursorColor,
            ),
          ],
        ),
      ),
    ),
  );
}
