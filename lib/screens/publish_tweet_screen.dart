import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/screens/tweet_reply_form.dart';

class PublishTweetScreen extends StatefulWidget {
  const PublishTweetScreen({Key? key}) : super(key: key);

  @override
  PublishTweetScreenState createState() => PublishTweetScreenState();
}

class PublishTweetScreenState extends State<PublishTweetScreen> {
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
