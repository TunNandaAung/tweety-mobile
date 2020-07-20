import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/following_list/following_list_bloc.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';
import 'package:tweety_mobile/widgets/user_card.dart';

class FollowListScreen extends StatefulWidget {
  final User profileUser;
  FollowListScreen({Key key, @required this.profileUser}) : super(key: key);

  @override
  _FollowListScreenState createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  final _scrollThreshold = 200.0;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    BlocProvider.of<FollowingListBloc>(context).add(
      FetchFollowingList(user: widget.profileUser),
    );
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      BlocProvider.of<FollowingListBloc>(context).add(
        FetchFollowingList(user: widget.profileUser),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var _tabs = ['tab1', 'tab2'];
    return Scaffold(
      body: DefaultTabController(
          length: _tabs.length, // This is the number of tabs.
          child: SafeArea(
            child: NestedScrollView(
              controller: _scrollController,
              physics: ScrollPhysics(parent: PageScrollPhysics()),
              headerSliverBuilder: (context, innderBoxIsScrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    leading: BackButton(
                      color: Colors.black,
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
                    delegate: TweetyTabs(50.0),
                  ),
                ];
              },
              body: TabBarView(children: [
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
                          BlocProvider.of<FollowingListBloc>(context).add(
                            RefreshFollowingList(user: widget.profileUser),
                          );
                        },
                      );
                    }
                    return LoadingIndicator();
                  },
                ),
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  key: PageStorageKey('followes'),
                  itemCount: 100,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Item $index'),
                    );
                  },
                ),
              ]),
            ),
          )),
    );
  }

  Widget _followingEmptyText() {
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
                  "When someone follows you, you'll see theme here.",
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

  TweetyTabs(this.size);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      height: 50.0,
      child: TabBar(
        unselectedLabelStyle:
            Theme.of(context).tabBarTheme.unselectedLabelStyle,
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
