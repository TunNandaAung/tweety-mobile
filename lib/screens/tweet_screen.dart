import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/children_reply/children_reply_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';
import 'package:tweety_mobile/widgets/reply.dart';
import 'package:tweety_mobile/widgets/tweet_card.dart';

class TweetScreen extends StatefulWidget {
  final Tweet tweet;
  final ReplyRepository replyRepository;
  const TweetScreen({Key key, this.tweet, this.replyRepository})
      : super(key: key);

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
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          // These are the slivers that show up in the "outer" scroll view.
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 5.0),
                  child: TweetCard(
                    tweet: widget.tweet,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SafeArea(
          top: false,
          bottom: false,
          child: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10.0,
                            offset: Offset(
                              -10,
                              -10,
                            ))
                      ]),
                  child: CustomScrollView(
                    key: PageStorageKey<String>(widget.tweet.body),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      BlocBuilder<ReplyBloc, ReplyState>(
                        builder: (context, state) {
                          if (state is ReplyError) {
                            return SliverToBoxAdapter(
                              child: Container(
                                child: Refresh(
                                  title: 'Couldn\'t load replies',
                                  onPressed: () {
                                    BlocProvider.of<ReplyBloc>(context).add(
                                      RefreshReply(tweetID: widget.tweet.id),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                          if (state is ReplyLoaded) {
                            if (state.replies.isEmpty) {
                              return SliverFillRemaining(
                                child: Center(
                                  child: Text('No replies yet!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
                                ),
                              );
                            }
                            return SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => index >=
                                        state.replies.length
                                    ? LoadingIndicator()
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 5.0,
                                        ),
                                        child: Container(
                                            child:
                                                BlocProvider<ChildrenReplyBloc>(
                                          create: (context) =>
                                              ChildrenReplyBloc(
                                            replyRepository:
                                                widget.replyRepository,
                                          ),
                                          child: ReplyWidget(
                                            reply: state.replies[index],
                                            tweet: widget.tweet,
                                          ),
                                        )),
                                      ),
                                childCount: state.hasReachedMax
                                    ? state.replies.length
                                    : state.replies.length + 1,
                              ),
                            );
                          }
                          return SliverFillRemaining(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
