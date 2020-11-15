import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/explore/explore_bloc.dart';
import 'package:tweety_mobile/blocs/search/tweet_search/tweet_search_bloc.dart';
import 'package:tweety_mobile/blocs/search/user_search/user_search_bloc.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/screens/search_screen.dart';
import 'package:tweety_mobile/widgets/buttons/avatar_button.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';
import 'package:tweety_mobile/widgets/cards/user_card.dart';

class ExploreScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  ExploreScreen({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _scrollController = ScrollController();
  Completer<void> _exploreRefreshCompleter;

  @override
  void initState() {
    super.initState();
    context.read<ExploreBloc>().add(
          ExploreUser(),
        );
    _exploreRefreshCompleter = Completer<void>();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<User> users = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocListener<ExploreBloc, ExploreState>(
        listener: (context, state) {
          if (state is ExploreUserLoaded) {
            _exploreRefreshCompleter?.complete();
            _exploreRefreshCompleter = Completer();
          }
        },
        child: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          strokeWidth: 1.0,
          onRefresh: () {
            context.read<ExploreBloc>().add(
                  RefreshExplore(),
                );
            return _exploreRefreshCompleter.future;
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
                  color: Theme.of(context).appBarTheme.iconTheme.color,
                ),
                leading: AvatarButton(
                  scaffoldKey: widget.scaffoldKey,
                ),
                title: InkWell(
                  onTap: () async {
                    User selected = await showSearch<User>(
                      context: context,
                      delegate: SearchScreen(context.read<UserSearchBloc>(),
                          context.read<TweetSearchBloc>()),
                    );
                    print(selected);
                  },
                  child: Container(
                    width: 400.0,
                    height: 36.0,
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(0xFFCBD5E0),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                        Icon(Icons.search)
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    'Explore Tweety',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              BlocBuilder<ExploreBloc, ExploreState>(
                builder: (context, state) {
                  if (state is ExploreUserLoading) {
                    return SliverFillRemaining(
                      child: LoadingIndicator(),
                    );
                  }
                  if (state is ExploreUserLoaded) {
                    users = state.users;
                    if (state.users.isEmpty) {
                      return SliverFillRemaining(
                        child: Text(
                          'No users yet!',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => index >= users.length
                            ? LoadingIndicator()
                            : UserCard(user: users[index]),
                        childCount: state.users.length,
                      ),
                    );
                  }
                  if (state is ExploreError) {
                    return SliverToBoxAdapter(
                      child: Container(
                        child: Refresh(
                          title: 'Couldn\'t load feed',
                          onPressed: () {
                            context.read<ExploreBloc>().add(
                                  RefreshExplore(),
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
