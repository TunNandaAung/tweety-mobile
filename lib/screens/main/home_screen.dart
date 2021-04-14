import 'dart:math' as math;
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/notification/notification_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/blocs/auth_profile/auth_profile_bloc.dart';
import 'package:tweety_mobile/models/bottom_nav.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/screens/messages_screen.dart';
import 'package:tweety_mobile/screens/main/explore_screen.dart';
import 'package:tweety_mobile/screens/main/notifications_screen.dart';
import 'package:tweety_mobile/screens/publish_tweet_screen.dart';
import 'package:tweety_mobile/screens/tweet/tweet_wrapper.dart';
import 'package:tweety_mobile/screens/tweet/tweets_screen.dart';
import 'package:tweety_mobile/widgets/nav/nav_drawer.dart';
import 'package:tweety_mobile/widgets/buttons/notifications_button.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  int _currentIndex = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    context.read<AuthProfileBloc>().add(
          GetAvatar(),
        );
    _scrollController.addListener(_onScroll);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    _animationController.dispose();
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

  void changePage(int index) {
    _animationController.forward(from: 0);
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
    if (index == 2) {
      context.read<NotificationBloc>().add(ResetNotificationCounts());
    }
  }

  List<Tweet> tweets = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer('/'),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TweetBloc, TweetState>(
            listener: (context, state) {
              if (state is TweetPublished) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      elevation: 6.0,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Your tweet was published!"),
                        ],
                      ),
                      action: SnackBarAction(
                          label: 'View',
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    TweetWrapper(tweet: state.tweet),
                              ),
                            );
                          }),
                    ),
                  );
              }

              if (state is TweetDeleted) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      elevation: 6.0,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Your tweet was deleted!"),
                        ],
                      ),
                    ),
                  );
              }

              if (state is PublishTweetError) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      elevation: 6.0,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Colors.red,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Couldn't publish tweet"),
                        ],
                      ),
                    ),
                  );
              }
            },
          ),
        ],
        child: SizedBox.expand(
          child: PageView(
            physics:
                NeverScrollableScrollPhysics(), // Disable swipe to change page
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              TweetsScreen(
                scaffoldKey: _scaffoldKey,
                scaffoldMessengerKey: _scaffoldMessengerKey,
              ),
              ExploreScreen(scaffoldKey: _scaffoldKey),
              MessagesScreen(scaffoldKey: _scaffoldKey),
              NotificationsScreen(scaffoldKey: _scaffoldKey),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: changePage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).bottomAppBarTheme.color,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 1.0,
        iconSize: 27.0,

        // items: bottomNavItems
        //     .asMap()
        //     .map((key, value) => MapEntry(
        //           key,
        //           BottomNavigationBarItem(
        //             title: Text(''),
        //             icon: Container(
        //               padding: const EdgeInsets.symmetric(
        //                 horizontal: 16.0,
        //               ),
        //               decoration: BoxDecoration(
        //                 color: _currentIndex == key
        //                     ? Theme.of(context).primaryColor
        //                     : Colors.transparent,
        //                 borderRadius: BorderRadius.circular(20.0),
        //               ),
        //               child: _currentIndex == key
        //                   ? Icon(value.activeIcon)
        //                   : Icon(value.defaultIcon),
        //             ),
        //           ),
        //         ))
        //     .values
        //     .toList(),
        items: [
          BottomNavigationBarItem(
            label: '',
            icon: _currentIndex == 0
                ? Icon(bottomNavItems[0].activeIcon,
                    color: Theme.of(context).primaryColor)
                : Icon(bottomNavItems[0].defaultIcon),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: _currentIndex == 1
                ? Icon(bottomNavItems[1].activeIcon,
                    color: Theme.of(context).primaryColor)
                : Icon(bottomNavItems[1].defaultIcon),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: _currentIndex == 2
                ? Icon(bottomNavItems[2].activeIcon,
                    color: Theme.of(context).primaryColor)
                : Icon(bottomNavItems[2].defaultIcon),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: NotificationButton(
              bubbleColor: Colors.red,
              icon: _currentIndex == 3
                  ? Icon(bottomNavItems[3].activeIcon,
                      color: Theme.of(context).primaryColor)
                  : Icon(bottomNavItems[3].defaultIcon),
            ),
          ),
        ],
      ),
      floatingActionButton: OpenContainer(
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(65.0),
            ),
          ),
          closedColor: Theme.of(context).primaryColor,
          closedElevation: 0.0,
          transitionDuration: Duration(milliseconds: 500),
          openBuilder: (context, action) => PublishTweetScreen(),
          transitionType: ContainerTransitionType.fade,
          closedBuilder: (BuildContext context, VoidCallback openContainer) {
            return Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [Color(0xFF2F80ED), Color(0xFF56CCF2)],
                // ),
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF2F80ED).withOpacity(.8),
                    offset: Offset(0.0, 8.0),
                    blurRadius: 8.0,
                  ),
                  BoxShadow(
                    color: Color(0xFF2F80ED).withOpacity(.8),
                    offset: Offset(8.0, 0.0),
                    blurRadius: 8.0,
                  )
                ],
              ),
              child: RawMaterialButton(
                shape: CircleBorder(),
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, child) {
                    return Transform.rotate(
                      angle: _animationController.value * math.pi,
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.add,
                    size: 35.0,
                    color: Colors.white,
                  ),
                ),
                onPressed: openContainer,
              ),
            );
          }),
    );
  }
}
