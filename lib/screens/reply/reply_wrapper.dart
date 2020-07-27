import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/screens/tweet/tweet_reply_screen.dart';
import 'package:tweety_mobile/services/reply_api_client.dart';

class ReplyWrapper extends StatelessWidget {
  final Reply reply;

  const ReplyWrapper({Key key, this.reply}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final replyJson = ModalRoute.of(context).settings.arguments;
    final reply = replyJson != null ? Reply.fromJson(replyJson) : this.reply;
    final ReplyRepository replyRepository = ReplyRepository(
      replyApiClient: ReplyApiClient(httpClient: http.Client()),
    );
    return BlocProvider<ReplyBloc>(
      create: (context) => ReplyBloc(replyRepository: replyRepository),
      child: TweetReplyScreen(
        reply: reply,
        replyRepository: replyRepository,
      ),
    );
  }
}
