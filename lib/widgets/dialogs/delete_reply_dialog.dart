import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:tweety_mobile/models/reply.dart';

Future<void> deleteReplyDialog(context, Reply reply, VoidCallback onPressed) {
  return showModal<void>(
    context: context,
    configuration: FadeScaleTransitionConfiguration(),
    builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(
        'Delete Reply?',
        style: TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
      ),
      content: Text(
        'Are you sure? This can\'t be undone.',
        style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Theme.of(context).textSelectionTheme.cursorColor),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 90.0,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0)),
                  backgroundColor: Colors.red[600],
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: onPressed,
              ),
            ),
            SizedBox(width: 15.0),
            SizedBox(
              width: 90.0,
              child: TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    backgroundColor: Color(0xFF4A5568),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
          ],
        ),
      ],
    ),
  );
}
