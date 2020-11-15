import 'package:flutter/material.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/widgets/dialogs/delete_tweet_dialog.dart';

class TweetActionsModal {
  mainBottomSheet(BuildContext context, Tweet tweet) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 70.0,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 10.0),
                Container(
                  height: 4.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                SizedBox(height: 10.0),
                tweet.user.username == Prefer.prefs.getString('userName')
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          deleteTweetDialog(context, tweet.id);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 10.0),
                            Text(
                              'Delete Tweet',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption
                                  .copyWith(color: Colors.red),
                            )
                          ],
                        ),
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.person_add,
                            color: Theme.of(context)
                                .textSelectionTheme
                                .cursorColor,
                          ),
                          SizedBox(width: 10.0),
                          Text('Unfollow ${tweet.user.name}',
                              style: Theme.of(context).textTheme.caption)
                        ],
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}
