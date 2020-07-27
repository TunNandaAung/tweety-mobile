import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tweety_mobile/blocs/profile/profile_reply/profile_reply_bloc.dart';
import 'package:tweety_mobile/blocs/profile/profile_tweet/profile_tweet_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/repositories/tweet_repository.dart';
import 'package:tweety_mobile/screens/profile/profile_screen.dart';
import 'package:tweety_mobile/services/reply_api_client.dart';
import 'package:tweety_mobile/services/tweet_api_client.dart';

class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = http.Client();
    final username = ModalRoute.of(context).settings.arguments;

    final ReplyRepository replyRepository = ReplyRepository(
      replyApiClient: ReplyApiClient(httpClient: client),
    );

    final TweetRepository tweetRepository = TweetRepository(
      tweetApiClient: TweetApiClient(httpClient: client),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileReplyBloc>(
          create: (context) =>
              ProfileReplyBloc(replyRepository: replyRepository),
        ),
        BlocProvider<ReplyBloc>(
          create: (context) => ReplyBloc(replyRepository: replyRepository),
        ),
        BlocProvider<ProfileTweetBloc>(
          create: (context) =>
              ProfileTweetBloc(tweetRepository: tweetRepository),
        ),
      ],
      child:
          ProfileScreen(username: username, replyRepository: replyRepository),
    );
  }
}
