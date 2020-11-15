import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/screens/tweet_reply_form.dart';

class PublishTweetScreen extends StatefulWidget {
  PublishTweetScreen({Key key}) : super(key: key);

  @override
  _PublishTweetScreenState createState() => _PublishTweetScreenState();
}

class _PublishTweetScreenState extends State<PublishTweetScreen> {
  @override
  Widget build(BuildContext context) {
    return TweetReplyForm(
      isReply: false,
      onSave: (body, image) {
        context.read<TweetBloc>().add(
              PublishTweet(body: body, image: image),
            );
      },
    );
  }
}
