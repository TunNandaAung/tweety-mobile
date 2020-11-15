import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/followers_list/followers_list_bloc.dart';
import 'package:tweety_mobile/blocs/following_list/following_list_bloc.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';
import 'package:tweety_mobile/widgets/cards/user_card.dart';

class FollowListScreen extends StatefulWidget {
  final User profileUser;
  FollowListScreen({Key key, @required this.profileUser}) : super(key: key);

  @override
  _FollowListScreenState createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen>
    with SingleTickerProviderStateMixin {
  final _scrollThreshold = 200.0;
  ScrollController _scrollController = ScrollController();
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    context.read<FollowingListBloc>().add(
          FetchFollowingList(user: widget.profileUser),
        );
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      context.read<FollowingListBloc>().add(
            FetchFollowingList(user: widget.profileUser),
          );
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 1:
          context.read<FollowersListBloc>().add(
                FetchFollowersList(user: widget.profileUser),
              );
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          physics: ScrollPhysics(parent: PageScrollPhysics()),
          headerSliverBuilder: (context, innderBoxIsScrolled) {
            return [
              SliverAppBar(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                leading: BackButton(
                  color: Theme.of(context).appBarTheme.iconTheme.color,
                ),
                title: Text(
                  widget.profileUser.name,
                  style: Theme.of(context).appBarTheme.textTheme.caption,
                ),
                centerTitle: true,
                floating: true,
                elevation: 0.0,
                snap: true,
              ),
              SliverPersistentHeader(
                pinned: true,
                delegate: TweetyTabs(50.0, controller: _tabController),
              ),
            ];
          },
          body: TabBarView(controller: _tabController, children: [
            BlocBuilder<FollowingListBloc, FollowingListState>(
              builder: (context, state) {
                if (state is FollowingListLoading) {
                  return LoadingIndicator();
                }
                if (state is FollowingListLoaded) {
                  var users = state.users;
                  if (state.users.isEmpty) {
                    return _followingEmptyText();
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) => index >= users.length
                        ? LoadingIndicator()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed(
                                  '/profile',
                                  arguments: widget.profileUser.username),
                              child: UserCard(
                                user: users[index],
                              ),
                            ),
                          ),
                    itemCount: state.hasReachedMax
                        ? state.users.length
                        : state.users.length + 1,
                  );
                }
                if (state is FollowingListError) {
                  return Refresh(
                    title: 'Couldn\'t load feed',
                    onPressed: () {
                      context.read<FollowingListBloc>().add(
                            RefreshFollowingList(user: widget.profileUser),
                          );
                    },
                  );
                }
                return LoadingIndicator();
              },
            ),
            BlocBuilder<FollowersListBloc, FollowersListState>(
              builder: (context, state) {
                if (state is FollowersListLoading) {
                  return LoadingIndicator();
                }
                if (state is FollowersListLoaded) {
                  var users = state.users;
                  if (state.users.isEmpty) {
                    return _followersEmptyText();
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) => index >= users.length
                        ? LoadingIndicator()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pushNamed(
                                  '/profile',
                                  arguments: widget.profileUser.username),
                              child: UserCard(
                                user: users[index],
                              ),
                            ),
                          ),
                    itemCount: state.hasReachedMax
                        ? state.users.length
                        : state.users.length + 1,
                  );
                }
                if (state is FollowersListError) {
                  return Refresh(
                    title: 'Couldn\'t load feed',
                    onPressed: () {
                      context.read<FollowersListBloc>().add(
                            RefreshFollowersList(user: widget.profileUser),
                          );
                    },
                  );
                }
                return LoadingIndicator();
              },
            ),
          ]),
        ),
      ),
    );
  }

  Widget _followingEmptyText() {
    return Center(
      child: widget.profileUser.username == Prefer.prefs.getString('userName')
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "You are not following anyone yet!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  "When you follows someone, you'll see them here.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "${widget.profileUser.name} is not following anyone yet!",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
    );
  }

  Widget _followersEmptyText() {
    return Center(
      child: widget.profileUser.username == Prefer.prefs.getString('userName')
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "You don't have any followers yet!",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5.0),
                Text(
                  "When someone follows you, you'll see them here.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "${widget.profileUser.name} don't have any followers yet!",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}

class TweetyTabs extends SliverPersistentHeaderDelegate {
  final double size;
  final TabController controller;

  TweetyTabs(this.size, {@required this.controller});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      height: 50.0,
      child: TabBar(
        controller: controller,
        unselectedLabelStyle:
            Theme.of(context).tabBarTheme.unselectedLabelStyle,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: <Widget>[
          Tab(
            text: "Following",
          ),
          Tab(
            text: "Followers",
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => size;

  @override
  double get minExtent => size;

  @override
  bool shouldRebuild(TweetyTabs oldDelegate) {
    return oldDelegate.size != size;
  }
}
