import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/children_reply/children_reply_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/screens/add_children_reply_screen.dart';
import 'package:tweety_mobile/services/reply_api_client.dart';

class AddChildrenReplyButton extends StatelessWidget {
  final Tweet tweet;
  final Reply parent;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const AddChildrenReplyButton(
      {Key key, @required this.tweet, this.scaffoldKey, this.parent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final ReplyRepository replyRepository = ReplyRepository(
    //   replyApiClient: ReplyApiClient(httpClient: http.Client()),
    // );
    return BlocProvider.value(
      value: BlocProvider.of<ChildrenReplyBloc>(context),
      child: AddChildrenReplyButtonWidget(
        tweet: tweet,
        parent: parent,
        scaffoldKey: scaffoldKey,
      ),
    );
  }
}

class AddChildrenReplyButtonWidget extends StatefulWidget {
  final Tweet tweet;
  final Reply parent;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const AddChildrenReplyButtonWidget(
      {Key key, @required this.tweet, this.scaffoldKey, this.parent})
      : super(key: key);

  @override
  _AddChildrenReplyButtonWidgetState createState() =>
      _AddChildrenReplyButtonWidgetState();
}

class _AddChildrenReplyButtonWidgetState
    extends State<AddChildrenReplyButtonWidget> {
  int get childrenCount => widget.parent.childrenCount;
  set childrenCount(int childrenCount) =>
      widget.parent.childrenCount = childrenCount;

  ChildrenReplyBloc _childrenReplyBloc;
  @override
  void initState() {
    super.initState();
    _childrenReplyBloc = BlocProvider.of<ChildrenReplyBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChildrenReplyBloc, ChildrenReplyState>(
      listener: (context, state) {
        if (state is ChildrenReplyAdded) {
          setState(() {
            childrenCount++;
          });
        }
        BlocProvider.of<TweetBloc>(context)
            .add(UpdateReplyCount(count: 1, tweetID: widget.tweet.id));
      },
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: _childrenReplyBloc,
                child: AddChildrenReplyScreen(
                  tweetID: widget.tweet.id,
                  parent: widget.parent,
                ),
              ),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            childrenCount > 0
                ? Padding(
                    padding: EdgeInsets.only(right: 3.0),
                    child: Text(
                      childrenCount.toString(),
                      style: TextStyle(
                        color: Color(0xFFA0AEC0),
                      ),
                    ),
                  )
                : Container(),
            Icon(
              Icons.comment,
              size: 18.0,
              color: Color(0xFFA0AEC0),
            ),
          ],
        ),
      ),
    );
  }
}
