import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/explore/explore_bloc.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/widgets/avatar_button.dart';
import 'package:tweety_mobile/widgets/follow_button.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';

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
    BlocProvider.of<ExploreBloc>(context).add(
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
            BlocProvider.of<ExploreBloc>(context).add(
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
                  color: Colors.black,
                ),
                leading: AvatarButton(
                  scaffoldKey: widget.scaffoldKey,
                ),
                title: Text(
                  'Explore',
                  style: TextStyle(letterSpacing: 1.0, color: Colors.black),
                ),
                centerTitle: true,
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
                            : Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 5.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Theme.of(context).cardColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 5.0,
                                    ),
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: ListTile(
                                        contentPadding: EdgeInsets.all(8.0),
                                        leading: CircleAvatar(
                                          radius: 25.0,
                                          backgroundImage: NetworkImage(
                                            users[index].avatar,
                                          ),
                                          backgroundColor:
                                              Theme.of(context).cardColor,
                                        ),
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                RichText(
                                                  text: TextSpan(
                                                    text: users[index].name,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption,
                                                  ),
                                                ),
                                                Text(
                                                  '@' + users[index].username,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                )
                                              ],
                                            ),
                                            FollowButton(user: users[index]),
                                          ],
                                        ),
                                        subtitle: Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                users[index].description ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
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
                            BlocProvider.of<ExploreBloc>(context).add(
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
