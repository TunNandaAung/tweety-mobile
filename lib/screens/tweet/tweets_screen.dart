import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tweety_mobile/blocs/notification/notification_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/screens/tweet/tweet_wrapper.dart';
import 'package:tweety_mobile/widgets/buttons/avatar_button.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';
import 'package:tweety_mobile/widgets/cards/tweet_card.dart';

class TweetsScreen extends StatefulWidget {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
  final GlobalKey<ScaffoldState> scaffoldKey;

  TweetsScreen(
      {Key key,
      @required this.scaffoldMessengerKey,
      @required this.scaffoldKey})
      : super(key: key);

  @override
  _TweetsScreenState createState() => _TweetsScreenState();
}

class _TweetsScreenState extends State<TweetsScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  Completer<void> _tweetRefreshCompleter;

  @override
  void initState() {
    super.initState();
    context.read<TweetBloc>().add(
          FetchTweet(),
        );
    context.read<NotificationBloc>().add(
          FetchNotificationCounts(),
        );
    _scrollController.addListener(_onScroll);
    _tweetRefreshCompleter = Completer<void>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      context.read<TweetBloc>().add(
            FetchTweet(),
          );
    }
  }

  List<Tweet> tweets = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocListener<TweetBloc, TweetState>(
        listener: (context, state) {
          if (state is TweetLoaded) {
            _tweetRefreshCompleter?.complete();
            _tweetRefreshCompleter = Completer();
          }
        },
        child: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          strokeWidth: 1.0,
          onRefresh: () {
            context.read<TweetBloc>().add(
                  RefreshTweet(),
                );
            return _tweetRefreshCompleter.future;
          },
          child: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 20.0,
                floating: true,
                iconTheme: IconThemeData(
                  color: Theme.of(context).textSelectionTheme.cursorColor,
                ),
                leading: AvatarButton(
                  scaffoldKey: widget.scaffoldKey,
                ),
                title: SvgPicture.asset(
                  'assets/images/tweety-logo.svg',
                ),
                centerTitle: true,
              ),
              BlocBuilder<TweetBloc, TweetState>(
                builder: (context, state) {
                  if (state is TweetLoading) {
                    return SliverFillRemaining(
                      child: LoadingIndicator(),
                    );
                  }
                  if (state is TweetLoaded) {
                    tweets = state.tweets;
                    if (state.tweets.isEmpty) {
                      return SliverFillRemaining(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "No tweets yet!",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            "When you follows someone, you'll see their tweets here.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ));
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => index >= tweets.length
                            ? LoadingIndicator()
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 5.0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => TweetWrapper(
                                          tweet: tweets[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: TweetCard(
                                    tweet: tweets[index],
                                    scaffoldMessengerKey:
                                        widget.scaffoldMessengerKey,
                                  ),
                                ),
                              ),
                        childCount: state.hasReachedMax
                            ? state.tweets.length
                            : state.tweets.length + 1,
                      ),
                    );
                  }
                  if (state is TweetError) {
                    return SliverToBoxAdapter(
                      child: Container(
                        child: Refresh(
                          title: 'Couldn\'t load feed',
                          onPressed: () {
                            context.read<TweetBloc>().add(
                                  RefreshTweet(),
                                );
                          },
                        ),
                      ),
                    );
                  }
                  return SliverFillRemaining(
                    child: LoadingIndicator(size: 21.0),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
