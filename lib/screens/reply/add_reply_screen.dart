import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/screens/tweet_reply_form.dart';

class AddReplyScreen extends StatefulWidget {
  final Tweet tweet;
  final bool? shouldDisplayTweet;
  const AddReplyScreen({Key? key, required this.tweet, this.shouldDisplayTweet})
      : super(key: key);

  @override
  AddReplyScreenState createState() => AddReplyScreenState();
}

class AddReplyScreenState extends State<AddReplyScreen> {
  @override
  Widget build(BuildContext context) {
    return TweetReplyForm(
      isReply: true,
      shouldDisplayTweet: widget.shouldDisplayTweet ?? false,
      owner: widget.tweet.user,
      onSave: (body, image) {
        context.read<ReplyBloc>().add(
              AddReply(
                tweetID: widget.tweet.id,
                body: body,
                image: image,
              ),
            );
      },
    );
  }
}
