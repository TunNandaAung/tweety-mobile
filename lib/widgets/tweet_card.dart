import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/widgets/add_reply_button.dart';
import 'package:tweety_mobile/widgets/like_dislike_buttons.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const TweetCard({Key key, this.tweet, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
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
              backgroundColor: Theme.of(context).cardColor,
            ),
            title: RichText(
              text: TextSpan(
                text: tweet.user.name,
                style: Theme.of(context).textTheme.caption,
                children: [
                  TextSpan(
                    text: "@${tweet.user.username}  " +
                        timeago.format(tweet.createdAt, locale: 'en_short'),
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tweet.body,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  tweet.image != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Container(
                            height: 200.0,
                            width: 320.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(0, 5),
                                  blurRadius: 10.0,
                                )
                              ],
                              image: DecorationImage(
                                  image: NetworkImage(tweet.image),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        )
                      : Container()
                ],
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
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: LikeDislikeButtons(
                    tweet: tweet,
                  ),
                ),
                AddReplyButton(
                  tweet: tweet,
                  scaffoldKey: scaffoldKey,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
