import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/children_reply/children_reply_bloc.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:tweety_mobile/widgets/buttons/like_dislike_buttons.dart';
import 'package:tweety_mobile/widgets/modals/reply_actions_modal.dart';

class ChildrenReplyCard extends StatefulWidget {
  final Reply reply;
  const ChildrenReplyCard({Key? key, required this.reply}) : super(key: key);

  @override
  ChildrenReplyCardState createState() => ChildrenReplyCardState();
}

class ChildrenReplyCardState extends State<ChildrenReplyCard> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            leading: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/profile',
                  arguments: widget.reply.owner.username),
              child: CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage(
                  widget.reply.owner.avatar,
                ),
                backgroundColor: Theme.of(context).cardColor,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.of(context).pushNamed('/profile',
                      arguments: widget.reply.owner.username),
                  child: SizedBox(
                    width: size.width / 2.2,
                    child: RichText(
                      text: TextSpan(
                        text: "${widget.reply.owner.name}\n",
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 14.0),
                        children: [
                          TextSpan(
                            text: "@${widget.reply.owner.username}",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  timeago.format(widget.reply.createdAt, locale: 'en_short'),
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onPressed: () => ReplyActionsModal()
                      .mainBottomSheet(context, widget.reply, onTap: () {
                    Navigator.of(context).pop();
                    context.read<ChildrenReplyBloc>().add(
                          DeleteChildrenReply(reply: widget.reply),
                        );
                  }),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                widget.reply.body,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(90.0, 0.0, 50.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width / 3,
                  child: LikeDislikeButtons(
                    reply: widget.reply,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.reply.childrenCount > 0
                        ? Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: Text(
                              widget.reply.childrenCount.toString(),
                              style: const TextStyle(
                                color: Color(0xFFA0AEC0),
                              ),
                            ),
                          )
                        : Container(),
                    const Icon(
                      Icons.comment,
                      size: 18.0,
                      color: Color(0xFFA0AEC0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(color: Colors.grey[300]),
        ],
      ),
    );
  }
}
