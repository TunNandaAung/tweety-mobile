import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/screens/tweet_reply_form.dart';

class AddReplyScreen extends StatefulWidget {
  final tweetID;
  AddReplyScreen({Key key, @required this.tweetID}) : super(key: key);

  @override
  _AddReplyScreenState createState() => _AddReplyScreenState();
}

class _AddReplyScreenState extends State<AddReplyScreen> {
  @override
  Widget build(BuildContext context) {
    return TweetReplyForm(
      isReply: true,
      onSave: (body, image) {
        BlocProvider.of<ReplyBloc>(context).add(
          AddReply(
            tweetID: widget.tweetID,
            body: body,
            image: image,
          ),
        );
      },
    );
  }
}
