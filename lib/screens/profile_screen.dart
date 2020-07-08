import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/profile/profile_bloc.dart';
import 'package:tweety_mobile/blocs/profile_tweet/profile_tweet_bloc.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/screens/tweet_wrapper.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/tweet_card.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({Key key, this.username}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static double avatarMaximumRadius = 40.0;
  static double avatarMinimumRadius = 15.0;
  double avatarRadius = avatarMaximumRadius;
  double expandedHeader = 130.0;
  double translate = -avatarMaximumRadius;
  bool isExpanded = true;
  double offset = 0.0;

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context)
        .add(FetchProfile(username: widget.username));

    BlocProvider.of<ProfileTweetBloc>(context)
        .add(FetchProfileTweet(username: widget.username));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: NotificationListener<ScrollUpdateNotification>(
            onNotification: (scrollNotification) {
              final pixels = scrollNotification.metrics.pixels;

              // check if scroll is vertical ( left to right OR right to left)
              final scrollTabs = (scrollNotification.metrics.axisDirection ==
                      AxisDirection.right ||
                  scrollNotification.metrics.axisDirection ==
                      AxisDirection.left);

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
              physics: ClampingScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                      expandedHeight: expandedHeader,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
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
                                  color: Theme.of(context).cardColor,
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
                            return Container(
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
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 10.0),
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlue,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Text(
                                          "Following",
                                          style: TextStyle(
                                              fontSize: 17.0,
                                              color: Colors.white),
                                        ),
                                      ),
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
                    delegate: TweetyTabs(50.0),
                  ),
                ];
              },
              body: TabBarView(children: <Widget>[
                BlocBuilder<ProfileTweetBloc, ProfileTweetState>(
                  builder: (context, state) {
                    if (state is ProfileTweetLoading) {
                      return LoadingIndicator();
                    }

                    if (state is ProfileTweetLoaded) {
                      var tweets = state.tweets;
                      if (tweets.isEmpty) {
                        return Text(
                          'No tweets yet!',
                          style: Theme.of(context).textTheme.caption,
                        );
                      }

                      return ListView.builder(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          itemBuilder: (context, index) =>
                              index >= tweets.length
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
                                                  TweetWrapper(
                                                      tweet: tweets[index]),
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
                ListView.builder(
                  itemBuilder: ((context, index) {
                    return Tweet();
                  }),
                ),
              ]),
            ),
          ),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(1, 10),
              blurRadius: 10.0,
            )
          ]),
      height: size,
      child: TabBar(
        isScrollable: true,
        unselectedLabelStyle:
            Theme.of(context).tabBarTheme.unselectedLabelStyle,
        labelStyle: Theme.of(context).tabBarTheme.labelStyle,
        tabs: <Widget>[
          Tab(
            text: "Tweets",
          ),
          Tab(
            text: "Tweets & replies",
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
          child: CircleAvatar(
            radius: size,
            backgroundImage: avatar == null
                ? AssetImage("assets/images/twitter_flutter_logo.jpg")
                : NetworkImage(avatar),
          ),
        ),
      ),
    );
  }
}
