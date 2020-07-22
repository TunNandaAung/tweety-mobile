import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Icon mapNotificationTypeToIcon(String type) {
  Icon icon;
  switch (type) {
    case "App\\Notifications\\YouWereFollowed":
      icon = Icon(Icons.person_add, color: Color(0xFF4299E1));
      break;
    case "App\\Notifications\\YouWereMentioned":
      icon = Icon(Icons.alternate_email, color: Color(0xFF9F7AEA));
      break;
    case "App\\Notifications\\RecentlyTweeted":
      icon = Icon(Icons.note_add, color: Color(0xFF38B2AC));
      break;
    case "App\\Notifications\\TweetWasLiked":
      icon = Icon(Icons.thumb_up, color: Color(0xFF3182CE));
      break;
    case "App\\Notifications\\TweetWasDisliked":
      icon = Icon(Icons.thumb_down, color: Color(0xFFF56565));
      break;

    case "App\\Notifications\\ReceivedNewReply":
      icon = Icon(Icons.comment, color: Color(0xFF667EEA));
      break;
  }

  return icon;
}

List<String> parseBody(String body) {
  final RegExp exp = RegExp(
    r'<a[^>]*>([^<]+)<\/a>',
  );

  var matches = exp.allMatches(body);

  for (var match in matches) {
    body = body.replaceAll(match.group(0), match.group(1));
  }

  List<String> stringList = body.split(" ");

  return stringList;
}

TextSpan bodyTextSpan(String body, BuildContext context) {
  return TextSpan(
      text: body + " ",
      style: body.trim().startsWith('@')
          ? Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Theme.of(context).primaryColor)
          : Theme.of(context).textTheme.bodyText1,
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          if (body.trim().startsWith('@')) {
            Navigator.of(context).pushNamed('/profile',
                arguments: body.trim().replaceFirst('@', ''));
          }
        });
}
