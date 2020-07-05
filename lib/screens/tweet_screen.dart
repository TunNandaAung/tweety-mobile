import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
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
    var _tabs = ['tab1', 'tab2'];
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
                      horizontal: 8.0, vertical: 10.0),
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
              return CustomScrollView(
                key: PageStorageKey<String>(widget.tweet.body),
                slivers: <Widget>[
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                        context),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 8.0),
                    sliver: BlocBuilder<ReplyBloc, ReplyState>(
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
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ),
                            );
                          }
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => index >= state.replies.length
                                  ? LoadingIndicator()
                                  : Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 5.0,
                                      ),
                                      child: ReplyWidget(
                                        reply: state.replies[index],
                                      ),
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
                  )
                ],
              );
            },
          ),
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          children: <Widget>[
            ListTile(
              contentPadding: EdgeInsets.all(8.0),
              leading: CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  reply.owner.avatar,
                ),
              ),
              title: RichText(
                text: TextSpan(
                  text: reply.owner.name,
                  style: Theme.of(context).textTheme.caption,
                  children: [
                    TextSpan(
                      text: "@${reply.owner.username}  " +
                          timeago.format(reply.createdAt, locale: 'en_short'),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  reply.body,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ),
            Divider(
              color: Colors.grey[300],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(90.0, 0.0, 50.0, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      reply.likesCount > 0
                          ? Padding(
                              padding: EdgeInsets.only(right: 3.0),
                              child: Text(
                                reply.likesCount.toString(),
                                style: TextStyle(
                                  color: reply.isLiked
                                      ? Color(0xFF68D391)
                                      : Color(0xFFA0AEC0),
                                ),
                              ),
                            )
                          : Container(),
                      Icon(
                        Icons.thumb_up,
                        size: 18.0,
                        color: reply.isLiked
                            ? Color(0xFF68D391)
                            : Color(0xFFA0AEC0),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      reply.dislikesCount > 0
                          ? Padding(
                              padding: EdgeInsets.only(right: 3.0),
                              child: Text(
                                reply.dislikesCount.toString(),
                                style: TextStyle(
                                  color: reply.isDisliked
                                      ? Color(0xFFE53E3E)
                                      : Color(0xFFA0AEC0),
                                ),
                              ),
                            )
                          : Container(),
                      Icon(
                        Icons.thumb_down,
                        size: 18.0,
                        color: reply.isDisliked
                            ? Color(0xFFE53E3E)
                            : Color(0xFFA0AEC0),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      reply.childrenCount > 0
                          ? Padding(
                              padding: EdgeInsets.only(right: 3.0),
                              child: Text(
                                reply.childrenCount.toString(),
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
