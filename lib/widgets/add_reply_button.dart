import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/services/reply_api_client.dart';
import 'package:tweety_mobile/screens/add_reply_screen.dart';

class AddReplyButton extends StatelessWidget {
  final Tweet tweet;

  const AddReplyButton({Key key, @required this.tweet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReplyRepository replyRepository = ReplyRepository(
      replyApiClient: ReplyApiClient(httpClient: http.Client()),
    );
    return BlocProvider<ReplyBloc>(
      create: (context) => ReplyBloc(replyRepository: replyRepository),
      child: AddReplyButtonWidget(
        tweet: tweet,
        replyRepository: replyRepository,
      ),
    );
  }
}

class AddReplyButtonWidget extends StatefulWidget {
  final Tweet tweet;
  final ReplyRepository replyRepository;
  const AddReplyButtonWidget(
      {Key key, @required this.tweet, this.replyRepository})
      : super(key: key);

  @override
  _AddReplyButtonWidgetState createState() => _AddReplyButtonWidgetState();
}

class _AddReplyButtonWidgetState extends State<AddReplyButtonWidget> {
  int get repliesCount => widget.tweet.repliesCount;
  set repliesCount(int repliesCount) =>
      widget.tweet.repliesCount = repliesCount;
  ReplyBloc _replyBloc;
  @override
  void initState() {
    super.initState();
    _replyBloc = BlocProvider.of<ReplyBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReplyBloc, ReplyState>(
      listener: (context, state) {
        if (state is ReplyAdded) {
          setState(() {
            repliesCount++;
          });
        }
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          repliesCount > 0
              ? Padding(
                  padding: EdgeInsets.only(right: 3.0),
                  child: Text(
                    repliesCount.toString(),
                    style: TextStyle(
                      color: Color(0xFFA0AEC0),
                    ),
                  ),
                )
              : Container(),
          InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                          value: _replyBloc,
                          child: AddReplyScreen(tweetID: widget.tweet.id),
                        )),
              );
            },
            child: Icon(
              Icons.comment,
              size: 18.0,
              color: Color(0xFFA0AEC0),
            ),
          ),
        ],
      ),
    );
  }
}
