import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:tweety_mobile/blocs/children_reply/children_reply_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/widgets/cards/children_reply.dart';
import 'package:tweety_mobile/widgets/buttons/like_dislike_buttons.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/modals/reply_actions_modal.dart';
import 'package:tweety_mobile/widgets/buttons/add_children_reply_button.dart';

class ReplyWidget extends StatefulWidget {
  final Reply reply;
  final Tweet tweet;
  final Reply replyingTo;
  final bool isProfileReply;

  const ReplyWidget(
      {Key key,
      @required this.reply,
      this.tweet,
      this.replyingTo,
      this.isProfileReply = false})
      : super(key: key);

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
    var size = MediaQuery.of(context).size;

    return BlocListener<ChildrenReplyBloc, ChildrenReplyState>(
      listener: (context, state) {
        if (state is ChildrenReplyLoaded) {
          setState(() {
            isLoading = false;
            childrenReplies = state.childrenReplies;
          });
        }
        if (state is ChildrenReplyAdded) {
          // var currentState = widget.scaffoldKey == null
          //     ? Scaffold.of(context)
          //     : widget.scaffoldKey.currentState;
          // childrenReplies.add(state.reply);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your reply was added!"),
                  ],
                ),
              ),
            );
        }
        if (state is ChildrenReplyDeleted) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Theme.of(context).primaryColor,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Your reply was deleted!"),
                  ],
                ),
              ),
            );
        }
        if (state is AddChildrenReplyError) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                elevation: 6.0,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: Colors.red,
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Couldn't add reply."),
                  ],
                ),
              ),
            );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          widget.isProfileReply
              ? Text(
                  widget.replyingTo != null
                      ? 'Replying to @' +
                          widget.replyingTo.owner.username +
                          "reply"
                      : 'Replying to @' + widget.tweet.user.username + " tweet",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Theme.of(context).primaryColor))
              : Container(),
          widget.replyingTo != null && widget.isProfileReply
              ? _parentReply(reply: widget.replyingTo)
              : Container(),
          ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: InkWell(
              onTap: () => Navigator.of(context).pushNamed('/profile',
                  arguments: widget.reply.owner.username),
              child: CircleAvatar(
                radius: 25.0,
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
                  child: Container(
                    width: size.width / 2,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: widget.reply.owner.name + "\n",
                        style: Theme.of(context).textTheme.caption,
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
                  icon: Icon(Icons.keyboard_arrow_down,
                      color: Theme.of(context).textSelectionTheme.cursorColor),
                  onPressed: () => ReplyActionsModal()
                      .mainBottomSheet(context, widget.reply, onTap: () {
                    Navigator.of(context).pop();
                    context.read<ReplyBloc>().add(
                          DeleteReply(reply: widget.reply),
                        );
                  }),
                ),
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                widget.reply.body,
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(90.0, 0.0, 50.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: LikeDislikeButtons(
                    reply: widget.reply,
                  ),
                ),
                BlocProvider.value(
                  value: context.watch<ChildrenReplyBloc>(),
                  child: AddChildrenReplyButton(
                    tweet: widget.tweet,
                    parent: widget.reply,
                  ),
                ),
              ],
            ),
          ),
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
                return LoadingIndicator(size: 15.0);
              }
              if (state is ChildrenReplyLoaded) {
                return _fetchMore(state.repliesLeft, state);
              }

              return widget.reply.childrenCount > 0
                  ? _fetchMore(widget.reply.childrenCount, state)
                  : Container();
            },
          ),
          widget.isProfileReply ? Divider() : Container(),
        ],
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
                    context.read<ChildrenReplyBloc>().add(
                          FetchChildrenReply(
                              parentID: widget.reply.id,
                              childrenCount: repliesLeft),
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

  Widget _parentReply({Reply reply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(8.0),
          leading: InkWell(
            child: CircleAvatar(
              radius: 25.0,
              backgroundImage: NetworkImage(
                reply.owner.avatar,
              ),
              backgroundColor: Theme.of(context).cardColor,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              InkWell(
                onTap: () => Navigator.of(context)
                    .pushNamed('/profile', arguments: reply.owner.username),
                child: Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: reply.owner.name + "\n",
                      style: Theme.of(context).textTheme.caption,
                      children: [
                        TextSpan(
                          text: "@${reply.owner.username}",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                timeago.format(reply.createdAt, locale: 'en_short'),
                style: Theme.of(context).textTheme.bodyText2,
              ),
              IconButton(
                icon: Icon(Icons.keyboard_arrow_down,
                    color: Theme.of(context).textSelectionTheme.cursorColor),
                onPressed: () => ReplyActionsModal()
                    .mainBottomSheet(context, reply, onTap: () {
                  Navigator.of(context).pop();
                  context.read<ReplyBloc>().add(
                        DeleteReply(reply: reply),
                      );
                }),
              ),
            ],
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              widget.reply.body,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(90.0, 0.0, 50.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: LikeDislikeButtons(
                  reply: widget.reply,
                ),
              ),
              BlocProvider.value(
                value: context.watch<ChildrenReplyBloc>(),
                child: AddChildrenReplyButton(
                  tweet: widget.tweet,
                  parent: widget.reply,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
