import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/screens/tweet_screen.dart';
import 'package:tweety_mobile/services/reply_api_client.dart';
import 'package:tweety_mobile/widgets/avatar_button.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';
import 'package:tweety_mobile/widgets/tweet_card.dart';

class TweetsScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  TweetsScreen({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _TweetsScreenState createState() => _TweetsScreenState();
}

class _TweetsScreenState extends State<TweetsScreen> {
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
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 20.0,
            floating: true,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            leading: AvatarButton(
              scaffoldKey: widget.scaffoldKey,
            ),
            title: Text(
              'Tweety',
              style: TextStyle(letterSpacing: 1.0, color: Colors.black),
            ),
            centerTitle: true,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () =>
                    BlocProvider.of<AuthenticationBloc>(context).add(
                  AuthenticationLoggedOut(),
                ),
              )
            ],
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
                            child: GestureDetector(
                              onTap: () {
                                final ReplyRepository replyRepository =
                                    ReplyRepository(
                                  replyApiClient:
                                      ReplyApiClient(httpClient: http.Client()),
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BlocProvider<ReplyBloc>(
                                            create: (context) => ReplyBloc(
                                                replyRepository:
                                                    replyRepository),
                                            child: TweetScreen(
                                                tweet: tweets[index],
                                                replyRepository:
                                                    replyRepository),
                                          )),
                                );
                              },
                              child: TweetCard(
                                tweet: tweets[index],
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
                        BlocProvider.of<TweetBloc>(context).add(
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
    );
  }
}
