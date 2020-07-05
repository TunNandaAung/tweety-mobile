import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';
import 'package:tweety_mobile/widgets/tweet_card.dart';

class TweetScreen extends StatefulWidget {
  final Tweet tweet;
  const TweetScreen({Key key, this.tweet}) : super(key: key);

  @override
  _TweetScreenState createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  @override
  void initState() {
    BlocProvider.of<ReplyBloc>(context).add(
      FetchReply(tweetID: widget.tweet.id),
    );
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      BlocProvider.of<ReplyBloc>(context).add(
        FetchReply(tweetID: widget.tweet.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Tweet',
          style: Theme.of(context).appBarTheme.textTheme.caption,
        ),
        centerTitle: true,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
        ),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        physics: ScrollPhysics(parent: PageScrollPhysics()),
        headerSliverBuilder: (context, innderBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                child: TweetCard(
                  tweet: widget.tweet,
                ),
              ),
            ),
          ];
        },
        // body: Column(
        //   children: <Widget>[
        //     SizedBox(height: 5.0),
        //     Expanded(
        //       child: Padding(
        //         padding: EdgeInsets.symmetric(horizontal: 8.0),
        //         child: Center(
        //           child: Text("REPLIES"),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        body: BlocBuilder<ReplyBloc, ReplyState>(
          builder: (context, state) {
            if (state is ReplyError) {
              return Refresh(
                title: 'Couldn\'t load replies',
                onPressed: () {
                  BlocProvider.of<ReplyBloc>(context).add(
                    RefreshReply(tweetID: widget.tweet.id),
                  );
                },
              );
            }
            if (state is ReplyLoaded) {
              if (state.replies.isEmpty) {
                return Center(
                  child: Text('No replies yet!',
                      style: Theme.of(context).textTheme.bodyText1),
                );
              }
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return index >= state.replies.length
                      ? LoadingIndicator(size: 18.0)
                      : ReplyWidget(reply: state.replies[index]);
                },
                itemCount: state.hasReachedMax
                    ? state.replies.length
                    : state.replies.length + 1,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class ReplyWidget extends StatelessWidget {
  final Reply reply;

  const ReplyWidget({Key key, @required this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Color(0xFFF5F7FB),
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                  color: Colors.black54.withOpacity(.12),
                  offset: Offset(0, 10),
                  blurRadius: 10)
            ]),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListTile(
            leading: Text(
              '${reply.id}',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            isThreeLine: true,
            subtitle: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text(
                reply.body,
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            dense: true,
          ),
        ),
      ),
    );
  }
}
