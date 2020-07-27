import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/screens/tweet/tweet_screen.dart';
import 'package:tweety_mobile/services/reply_api_client.dart';

class TweetWrapper extends StatelessWidget {
  final Tweet tweet;
  const TweetWrapper({Key key, this.tweet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _tweetJson = ModalRoute.of(context).settings.arguments;
    final _tweet = _tweetJson != null ? Tweet.fromJson(_tweetJson) : tweet;
    final ReplyRepository replyRepository = ReplyRepository(
      replyApiClient: ReplyApiClient(httpClient: http.Client()),
    );
    return BlocProvider<ReplyBloc>(
      create: (context) => ReplyBloc(replyRepository: replyRepository),
      child: TweetScreen(
        tweet: _tweet,
        replyRepository: replyRepository,
      ),
    );
  }
}
