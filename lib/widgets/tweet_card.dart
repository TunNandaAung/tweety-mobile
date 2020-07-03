import 'package:flutter/material.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:timeago/timeago.dart' as timeago;

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  const TweetCard({Key key, this.tweet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(10, 10),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(8.0),
        leading: CircleAvatar(
          radius: 30.0,
          backgroundImage: NetworkImage(
            tweet.user.avatar,
          ),
        ),
        title: RichText(
          text: TextSpan(
            text: tweet.user.name,
            style: Theme.of(context).textTheme.caption,
            children: [
              TextSpan(
                text: "@${tweet.user.username}  " +
                    timeago.format(tweet.createdAt),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            tweet.body,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
      ),
    );
  }
}
