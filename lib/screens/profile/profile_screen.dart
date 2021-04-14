import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/children_reply/children_reply_bloc.dart';
import 'package:tweety_mobile/blocs/profile/profile/profile_bloc.dart';
import 'package:tweety_mobile/blocs/profile/profile_reply/profile_reply_bloc.dart';
import 'package:tweety_mobile/blocs/profile/profile_tweet/profile_tweet_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/screens/profile/edit_profile_screen.dart';
import 'package:tweety_mobile/screens/profile/follow_list_wrapper.dart';
import 'package:tweety_mobile/screens/photo_view_screen.dart';
import 'package:tweety_mobile/screens/tweet/tweet_wrapper.dart';
import 'package:tweety_mobile/widgets/buttons/follow_button.dart';
import 'package:tweety_mobile/widgets/buttons/message_button.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';
import 'package:tweety_mobile/widgets/cards/reply.dart';
import 'package:tweety_mobile/widgets/cards/tweet_card.dart';

class ProfileScreen extends StatefulWidget {
  final String username;
  final ReplyRepository replyRepository;
  const ProfileScreen({Key key, this.username, this.replyRepository})
      : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  static double avatarMaximumRadius = 40.0;
  static double avatarMinimumRadius = 15.0;
  double avatarRadius = avatarMaximumRadius;
  double expandedHeader = 130.0;
  double translate = -avatarMaximumRadius;
  bool isExpanded = true;
  double offset = 0.0;

  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _scrollController.addListener(_onScroll);
    context.read<ProfileBloc>().add(FetchProfile(username: widget.username));

    context
        .read<ProfileTweetBloc>()
        .add(FetchProfileTweet(username: widget.username));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 1:
          context.read<ProfileReplyBloc>().add(
                FetchProfileReply(username: widget.username),
              );
          break;
      }
    }
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _tabController.index == 0
          ? context
              .read<ProfileTweetBloc>()
              .add(FetchProfileTweet(username: widget.username))
          : context
              .read<ProfileReplyBloc>()
              .add(FetchProfileReply(username: widget.username));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NotificationListener<ScrollUpdateNotification>(
          onNotification: (scrollNotification) {
            final pixels = scrollNotification.metrics.pixels;

            // check if scroll is vertical ( left to right OR right to left)
            final scrollTabs = (scrollNotification.metrics.axisDirection ==
                    AxisDirection.right ||
                scrollNotification.metrics.axisDirection == AxisDirection.left);

            if (!scrollTabs) {
              // and here prevents animation of avatar when you scroll tabs
              if (expandedHeader - pixels <= kToolbarHeight) {
                if (isExpanded) {
                  translate = 0.0;
                  setState(() {
                    isExpanded = false;
                  });
                }
              } else {
                translate = -avatarMaximumRadius + pixels;
                if (translate > 0) {
                  translate = 0.0;
                }
                if (!isExpanded) {
                  setState(() {
                    isExpanded = true;
                  });
                }
              }

              offset = pixels * 0.4;

              final newSize = (avatarMaximumRadius - offset);

              setState(() {
                if (newSize < avatarMinimumRadius) {
                  avatarRadius = avatarMinimumRadius;
                } else if (newSize > avatarMaximumRadius) {
                  avatarRadius = avatarMaximumRadius;
                } else {
                  avatarRadius = newSize;
                }
              });
            }
            return false;
          },
          child: NestedScrollView(
            controller: _scrollController,
            physics: ClampingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    expandedHeight: expandedHeader,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    iconTheme: Theme.of(context).appBarTheme.iconTheme,
                    leading: isExpanded
                        ? Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isExpanded
                                    ? Colors.black.withOpacity(.2)
                                    : Colors.black.withOpacity(.7),
                              ),
                              child: BackButton(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : BackButton(),
                    pinned: true,
                    elevation: 0.0,
                    forceElevated: true,
                    flexibleSpace: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, state) {
                        if (state is ProfileError) {
                          return Center(
                            child: Text(
                              'Couldn\'t load prodfile.',
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          );
                        }
                        if (state is ProfileLoading) {
                          return LoadingIndicator(
                            size: 21.0,
                          );
                        }
                        if (state is ProfileLoaded) {
                          return GestureDetector(
                            onTap: () => isExpanded
                                ? Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PhotoViewScreen(
                                        title: '',
                                        imageProvider:
                                            NetworkImage(state.user.banner),
                                      ),
                                    ),
                                  )
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: isExpanded
                                      ? Colors.transparent
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  image: isExpanded
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                          image:
                                              NetworkImage(state.user.banner),
                                        )
                                      : null),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: isExpanded
                                    ? Transform(
                                        transform: Matrix4.identity()
                                          ..translate(0.0, avatarMaximumRadius),
                                        child: TweetyAvatar(
                                          size: avatarRadius,
                                          avatar: state.user.avatar,
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    )),
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoaded) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  isExpanded
                                      ? SizedBox(
                                          height: avatarMinimumRadius * 2,
                                        )
                                      : TweetyAvatar(
                                          size: avatarMinimumRadius,
                                          avatar: state.user.avatar,
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: widget.username !=
                                            Prefer.prefs.getString('userName')
                                        ? Row(
                                            children: [
                                              MessageButton(
                                                  messageTo: state.user),
                                              const SizedBox(width: 5.0),
                                              FollowButton(user: state.user),
                                            ],
                                          )
                                        : EditProfileButton(user: state.user),
                                  )
                                ],
                              ),
                              TweetyHeader(user: state.user),
                            ],
                          ),
                        ),
                      );
                    }
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  },
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: TweetyTabs(50.0, controller: _tabController),
                ),
              ];
            },
            body: TabBarView(controller: _tabController, children: <Widget>[
              BlocBuilder<ProfileTweetBloc, ProfileTweetState>(
                builder: (context, state) {
                  if (state is ProfileTweetLoading) {
                    return LoadingIndicator();
                  }

                  if (state is ProfileTweetError) {
                    return Refresh(
                      title: "Couldn't load tweets!",
                      onPressed: () {
                        context
                            .read<ProfileTweetBloc>()
                            .add(FetchProfileTweet(username: widget.username));
                      },
                    );
                  }

                  if (state is ProfileTweetLoaded) {
                    var tweets = state.tweets;
                    if (tweets.isEmpty) {
                      return Center(
                          child: Text(
                        "No tweets yet!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.bold),
                      ));
                    }

                    return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        itemBuilder: (context, index) => index >= tweets.length
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
                                        builder: (context) =>
                                            TweetWrapper(tweet: tweets[index]),
                                      ),
                                    );
                                  },
                                  child: TweetCard(
                                    tweet: tweets[index],
                                  ),
                                ),
                              ),
                        itemCount: state.hasReachedMax
                            ? state.tweets.length
                            : state.tweets.length + 1);
                  }

                  return LoadingIndicator();
                },
              ),
              // ListView.builder(
              //   itemBuilder: ((context, index) {
              //     return Tweet();
              //   }),
              // ),
              BlocBuilder<ProfileReplyBloc, ProfileReplyState>(
                builder: (context, state) {
                  if (state is ProfileReplyLoading) {
                    return LoadingIndicator();
                  }

                  if (state is ProfileReplyError) {
                    return Refresh(
                      title: "Couldn't load replies!",
                      onPressed: () {
                        context
                            .read<ProfileReplyBloc>()
                            .add(FetchProfileReply(username: widget.username));
                      },
                    );
                  }

                  if (state is ProfileReplyLoaded) {
                    var replies = state.replies;
                    if (replies.isEmpty) {
                      return Center(
                          child: Text(
                        "No replies yet!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(fontWeight: FontWeight.bold),
                      ));
                    }

                    return ListView.builder(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        itemBuilder: (context, index) => index >= replies.length
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
                                            tweet: replies[index].tweet),
                                      ),
                                    );
                                  },
                                  child: MultiBlocProvider(
                                    providers: [
                                      BlocProvider<ChildrenReplyBloc>(
                                        create: (context) => ChildrenReplyBloc(
                                          replyRepository:
                                              widget.replyRepository,
                                        ),
                                      ),
                                      BlocProvider.value(
                                        value: context.read<ReplyBloc>(),
                                      ),
                                    ],
                                    child: ReplyWidget(
                                      reply: replies[index],
                                      tweet: replies[index].tweet,
                                      replyingTo: replies[index].parent ?? null,
                                      isProfileReply: true,
                                    ),
                                  ),
                                ),
                              ),
                        itemCount: state.hasReachedMax
                            ? state.replies.length
                            : state.replies.length + 1);
                  }

                  return LoadingIndicator();
                },
              ),
            ]),
          ),
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
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).canvasColor,
              offset: Offset(1, 10),
              blurRadius: 10.0,
            )
          ]),
      height: size,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        unselectedLabelStyle:
            Theme.of(context).tabBarTheme.unselectedLabelStyle,
        labelStyle: Theme.of(context).tabBarTheme.labelStyle,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: <Widget>[
          Tab(
            text: "Tweets",
          ),
          Tab(
            text: "Replies",
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

class TweetyHeader extends StatelessWidget {
  final User user;

  const TweetyHeader({Key key, this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            user.name,
            style: Theme.of(context).textTheme.caption.copyWith(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "@" + user.username,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            user.description ?? '',
            style: Theme.of(context).textTheme.bodyText1.copyWith(
                  fontSize: 15.0,
                ),
          ),
          SizedBox(
            height: 10.0,
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FollowListWrapper(
                      user: user,
                    ))),
            child: Row(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      text: user.followsCount.toString(),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: " Following",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ]),
                ),
                SizedBox(
                  width: 5.0,
                ),
                RichText(
                  text: TextSpan(
                      text: user.followersCount.toString(),
                      style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                          text: " Followers",
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ]),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Tweet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.all(6.0),
      leading: CircleAvatar(
        backgroundImage: AssetImage("assets/images/twitter_flutter_logo.jpg"),
      ),
      title: RichText(
        text: TextSpan(
            text: "Flutter",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
            children: [
              TextSpan(
                  text: "  @flutterio  04 Dec 18",
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
            ]),
      ),
      subtitle: Text(
        "We just announced the general availability of Flutter 1.0 at #FlutterLive! \n\nThank you to all the amazing engineers who made this possible and to our awesome community for their support.",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class TweetyAvatar extends StatelessWidget {
  final double size;
  final String avatar;

  const TweetyAvatar({Key key, this.size, this.avatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            // border: Border.all(
            //   color: Colors.grey[800],
            //   width: 2.0,
            // ),
            shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PhotoViewScreen(
                  title: '',
                  imageProvider: NetworkImage(avatar),
                ),
              ),
            ),
            child: CircleAvatar(
              radius: size,
              backgroundColor: Theme.of(context).cardColor,
              backgroundImage: avatar == null
                  ? AssetImage("assets/images/twitter_flutter_logo.jpg")
                  : NetworkImage(avatar),
            ),
          ),
        ),
      ),
    );
  }
}

class EditProfileButton extends StatelessWidget {
  final User user;
  const EditProfileButton({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.watch<ProfileBloc>(),
      child: TextButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditProfileScreen(
                user: user,
              ),
            ),
          );
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.transparent,
          onSurface: Colors.grey,
          padding: EdgeInsets.all(8.0),
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 1,
                style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.button.copyWith(
                color: Theme.of(context).primaryColor,
              ),
        ),
      ),
    );
  }
}
