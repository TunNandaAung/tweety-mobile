import 'package:flutter/material.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/widgets/dialogs/delete_reply_dialog.dart';

class ReplyActionsModal {
  mainBottomSheet(BuildContext context, Reply reply, {VoidCallback onTap}) {
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
                reply.owner.username == Prefer.prefs.getString('userName')
                    ? GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          deleteReplyDialog(context, reply, onTap);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 10.0),
                            Text(
                              'Delete Reply',
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
                          Text('Unfollow ${reply.owner.name}',
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
