import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/screens/photo_view_screen.dart';
import 'package:tweety_mobile/utils/helpers.dart';
import 'package:tweety_mobile/widgets/buttons/add_reply_button.dart';
import 'package:tweety_mobile/widgets/buttons/like_dislike_buttons.dart';
import 'package:tweety_mobile/widgets/modals/tweet_actions_modal.dart';

class TweetCard extends StatelessWidget {
  final Tweet tweet;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  const TweetCard({Key key, this.tweet, this.scaffoldMessengerKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).canvasColor,
            offset: Offset(10, 10),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed('/profile', arguments: tweet.user.username),
              child: CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  tweet.user.avatar,
                ),
                backgroundColor: Theme.of(context).cardColor,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed('/profile', arguments: tweet.user.username),
                  child: Container(
                    width: size.width / 1.93,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tweet.user.name,
                          style: Theme.of(context).textTheme.caption,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "@${tweet.user.username}",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  timeago.format(tweet.createdAt, locale: 'en_short'),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  color: Theme.of(context).textSelectionTheme.cursorColor,
                  onPressed: () =>
                      TweetActionsModal().mainBottomSheet(context, tweet),
                ),
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: parseBody(tweet.body)
                          .map((body) => bodyTextSpan(body, context,
                              Theme.of(context).textTheme.bodyText1))
                          .toList(),
                    ),
                  ),
                  tweet.image != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PhotoViewScreen(
                                    title: '',
                                    actionText: '',
                                    imageProvider: NetworkImage(tweet.image),
                                    onTap: () {},
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 200.0,
                              width: 320.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).canvasColor,
                                    offset: Offset(0, 5),
                                    blurRadius: 10.0,
                                  )
                                ],
                                image: DecorationImage(
                                    image: NetworkImage(tweet.image),
                                    fit: BoxFit.cover),
                              ),
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
                  child: AddReplyButtonWidget(
                    tweet: tweet,
                    scaffoldMessengerKey: scaffoldMessengerKey,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
