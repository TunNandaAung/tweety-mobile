import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/bloc/tweet_bloc.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';
import 'package:tweety_mobile/widgets/tweet_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<TweetBloc>(context).add(
      FetchTweet(),
    );
    _scrollController.addListener(_onScroll);
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
      BlocProvider.of<TweetBloc>(context).add(
        FetchTweet(),
      );
    }
  }

  List<Tweet> tweets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 20.0,
            floating: true,
            title: Text(
              'Tweety',
              style: TextStyle(letterSpacing: 1.0, color: Colors.black),
            ),
            centerTitle: true,
          ),
          SliverToBoxAdapter(child: SizedBox(height: 12.0)),
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
                    child: Text(
                      'No tweets yet!',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  );
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
                            child: TweetCard(
                              tweet: tweets[index],
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
                        BlocProvider.of<TweetBloc>(context).add(
                          RefreshTweet(),
                        );
                      },
                    ),
                  ),
                );
              }
              return SliverFillRemaining(
                child: LoadingIndicator(),
              );
            },
          ),
        ],
      ),
    );
  }
}
