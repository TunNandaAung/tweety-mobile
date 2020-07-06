import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:tweety_mobile/blocs/children_reply/children_reply_bloc.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/widgets/children_reply.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';

class ReplyWidget extends StatefulWidget {
  final Reply reply;

  const ReplyWidget({Key key, @required this.reply}) : super(key: key);

  @override
  _ReplyWidgetState createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  bool isButtonEnabled(ChildrenReplyState state) =>
      state is! ChildrenReplyLoading;

  List<Reply> childrenReplies = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChildrenReplyBloc, ChildrenReplyState>(
      listener: (context, state) {
        if (state is ChildrenReplyLoaded) {
          setState(() {
            isLoading = false;
            childrenReplies = state.childrenReplies;
          });
        }
      },
      child: Padding(
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
            Divider(color: Colors.grey[300]),
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
            Padding(
              padding: EdgeInsets.only(left: 18.0),
              child: Column(
                  children: childrenReplies
                      .map((reply) => ChildrenReply(
                            reply: reply,
                          ))
                      .toList()),
            ),
            BlocBuilder<ChildrenReplyBloc, ChildrenReplyState>(
              builder: (context, state) {
                if (state is ChildrenReplyLoading) {
                  return LoadingIndicator(
                    size: 20.0,
                    strokeWidth: 1.0,
                  );
                }
                if (state is ChildrenReplyLoaded) {
                  return _fetchMore(state.repliesLeft, state);
                }

                return widget.reply.childrenCount > 0
                    ? _fetchMore(widget.reply.childrenCount, state)
                    : Container();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _fetchMore(repliesLeft, state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        repliesLeft > 0
            ? GestureDetector(
                onTap: () {
                  if (isButtonEnabled(state)) {
                    setState(() {
                      isLoading = true;
                    });
                    BlocProvider.of<ChildrenReplyBloc>(context).add(
                      FetchChildrenReply(
                        parentID: widget.reply.id,
                        childrenCount: widget.reply.childrenCount,
                      ),
                    );
                  }
                },
                child: Text(
                  'View $repliesLeft more ' +
                      (repliesLeft > 1 ? 'replies' : 'reply'),
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              )
            : Container(),
      ],
    );
  }
}
