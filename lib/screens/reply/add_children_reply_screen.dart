import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/children_reply/children_reply_bloc.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/screens/tweet_reply_form.dart';

class AddChildrenReplyScreen extends StatefulWidget {
  final int tweetID;
  final Reply parent;
  const AddChildrenReplyScreen({
    Key? key,
    required this.tweetID,
    required this.parent,
  }) : super(key: key);

  @override
  AddChildrenReplyScreenState createState() => AddChildrenReplyScreenState();
}

class AddChildrenReplyScreenState extends State<AddChildrenReplyScreen> {
  @override
  Widget build(BuildContext context) {
    return TweetReplyForm(
      isReply: true,
      owner: widget.parent.owner,
      onSave: (body, image) {
        context.read<ChildrenReplyBloc>().add(
              AddChildrenReply(
                tweetID: widget.tweetID,
                body: body,
                image: image,
                parentID: widget.parent.id,
              ),
            );
      },
    );
  }
}
