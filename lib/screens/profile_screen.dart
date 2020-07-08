import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/profile/profile_bloc.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({Key key, this.username}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TabController _tabController;
  static double avatarMaximumRadius = 40.0;
  static double avatarMinimumRadius = 15.0;
  double avatarRadius = avatarMaximumRadius;
  double expandedHeader = 130.0;
  double translate = -avatarMaximumRadius;
  bool isExpanded = true;
  double offset = 0.0;
  String _title = "";

  @override
  void initState() {
    BlocProvider.of<ProfileBloc>(context)
        .add(FetchProfile(username: widget.username));
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
                      title: !isExpanded ? Text('test') : Text(''),
                      expandedHeight: expandedHeader,
                      backgroundColor: Colors.blue[500],
                      leading: BackButton(
                        color: isExpanded ? Colors.grey : Colors.white,
                      ),
                      pinned: true,
                      elevation: 5.0,
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
                            Container(
                              decoration: BoxDecoration(
                                  color: isExpanded
                                      ? Colors.transparent
                                      : Colors.blue[800],
                                  image: isExpanded
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          alignment: Alignment.bottomCenter,
                                          image:
                                              NetworkImage(state.user.avatar),
                                        )
                                      : null),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: isExpanded
                                    ? Transform(
                                        transform: Matrix4.identity()
                                          ..translate(0.0, avatarMaximumRadius),
                                        child: MyAvatar(
                                          size: avatarRadius,
                                        ),
                                      )
                                    : SizedBox.shrink(),
                              ),
                            );
                          }
                          return Container();
                        },
                      )),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              isExpanded
                                  ? SizedBox(
                                      height: avatarMinimumRadius * 2,
                                    )
                                  : MyAvatar(
                                      size: avatarMinimumRadius,
                                    ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "Following",
                                    style: TextStyle(
                                        fontSize: 17.0, color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                          TwitterHeader(),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: TweetyTabs(50.0),
                  ),
                ];
              },
              body: TabBarView(children: <Widget>[
                ListView.builder(
                  itemBuilder: ((context, index) {
                    return Tweet();
                  }),
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
      color: Colors.blueGrey[900],
      height: size,
      child: TabBar(
        isScrollable: true,
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

class TwitterHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Flutter",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22.0,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "@flutterio",
            style: TextStyle(
                color: Colors.grey,
                fontSize: 15.0,
                fontWeight: FontWeight.w200),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "Google’s mobile app SDK for building beautiful native apps on iOS and Android in record time // For support visit http://stackoverflow.com/tags/flutter",
            style: TextStyle(
              color: Colors.white,
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

class MyAvatar extends StatelessWidget {
  final double size;

  const MyAvatar({Key key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[800],
              width: 2.0,
            ),
            shape: BoxShape.circle),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: CircleAvatar(
            radius: size,
            backgroundImage:
                AssetImage("assets/images/twitter_flutter_logo.jpg"),
          ),
        ),
      ),
    );
  }
}
