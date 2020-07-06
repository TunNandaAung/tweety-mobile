import 'package:flutter/material.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChildrenReply extends StatefulWidget {
  final Reply reply;
  ChildrenReply({Key key, this.reply}) : super(key: key);

  @override
  _ChildrenReplyState createState() => _ChildrenReplyState();
}

class _ChildrenReplyState extends State<ChildrenReply> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                widget.reply.owner.avatar,
              ),
            ),
            title: RichText(
              text: TextSpan(
                text: widget.reply.owner.name,
                style: Theme.of(context).textTheme.caption,
                children: [
                  TextSpan(
                    text: "@${widget.reply.owner.username}  " +
                        timeago.format(widget.reply.createdAt,
                            locale: 'en_short'),
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
                widget.reply.body,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(90.0, 0.0, 50.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.reply.likesCount > 0
                        ? Padding(
                            padding: EdgeInsets.only(right: 3.0),
                            child: Text(
                              widget.reply.likesCount.toString(),
                              style: TextStyle(
                                color: widget.reply.isLiked
                                    ? Color(0xFF68D391)
                                    : Color(0xFFA0AEC0),
                              ),
                            ),
                          )
                        : Container(),
                    Icon(
                      Icons.thumb_up,
                      size: 18.0,
                      color: widget.reply.isLiked
                          ? Color(0xFF68D391)
                          : Color(0xFFA0AEC0),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.reply.dislikesCount > 0
                        ? Padding(
                            padding: EdgeInsets.only(right: 3.0),
                            child: Text(
                              widget.reply.dislikesCount.toString(),
                              style: TextStyle(
                                color: widget.reply.isDisliked
                                    ? Color(0xFFE53E3E)
                                    : Color(0xFFA0AEC0),
                              ),
                            ),
                          )
                        : Container(),
                    Icon(
                      Icons.thumb_down,
                      size: 18.0,
                      color: widget.reply.isDisliked
                          ? Color(0xFFE53E3E)
                          : Color(0xFFA0AEC0),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.reply.childrenCount > 0
                        ? Padding(
                            padding: EdgeInsets.only(right: 3.0),
                            child: Text(
                              widget.reply.childrenCount.toString(),
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
          ),
          Divider(),
        ],
      ),
    );
  }
}
