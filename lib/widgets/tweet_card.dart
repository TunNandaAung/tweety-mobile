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
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: CircleAvatar(
              radius: 25.0,
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
          Divider(
            color: Colors.grey[300],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(90.0, 0.0, 50.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    tweet.likesCount > 0
                        ? Padding(
                            padding: EdgeInsets.only(right: 3.0),
                            child: Text(
                              tweet.likesCount.toString(),
                              style: TextStyle(
                                color: tweet.isLiked
                                    ? Color(0xFF68D391)
                                    : Color(0xFFA0AEC0),
                              ),
                            ),
                          )
                        : Container(),
                    Icon(
                      Icons.thumb_up,
                      size: 18.0,
                      color:
                          tweet.isLiked ? Color(0xFF68D391) : Color(0xFFA0AEC0),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    tweet.dislikesCount > 0
                        ? Padding(
                            padding: EdgeInsets.only(right: 3.0),
                            child: Text(
                              tweet.dislikesCount.toString(),
                              style: TextStyle(
                                color: tweet.isDisliked
                                    ? Color(0xFFE53E3E)
                                    : Color(0xFFA0AEC0),
                              ),
                            ),
                          )
                        : Container(),
                    Icon(
                      Icons.thumb_down,
                      size: 18.0,
                      color: tweet.isDisliked
                          ? Color(0xFFE53E3E)
                          : Color(0xFFA0AEC0),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    tweet.repliesCount > 0
                        ? Padding(
                            padding: EdgeInsets.only(right: 3.0),
                            child: Text(
                              tweet.repliesCount.toString(),
                              style: TextStyle(
                                color: Color(0xFFA0AEC0),
                              ),
                            ),
                          )
                        : Container(),
                    Icon(
                      Icons.comment,
                      size: 18.0,
                      color: Color(0xFFA0AEC0),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
