import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/blocs/auth_profile/auth_profile_bloc.dart';
import 'package:tweety_mobile/models/bottom_nav.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/screens/explore_screen.dart';
import 'package:tweety_mobile/screens/notifications_screen.dart';
import 'package:tweety_mobile/screens/tweets_screen.dart';
import 'package:tweety_mobile/widgets/nav_drawer.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  int _currentIndex = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    BlocProvider.of<AuthProfileBloc>(context).add(
      GetAvatar(),
    );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
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

  void changePage(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  List<Tweet> tweets = [];
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer('/'),
      body: SizedBox.expand(
        child: PageView(
          physics:
              NeverScrollableScrollPhysics(), // Disable swipe to change page
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            TweetsScreen(scaffoldKey: _scaffoldKey),
            ExploreScreen(),
            NotificationScreen(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: changePage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFEDF2F7),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        elevation: 1.0,
        items: bottomNavItems
            .asMap()
            .map((key, value) => MapEntry(
                  key,
                  BottomNavigationBarItem(
                    title: Text(''),
                    icon: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 3.0,
                        horizontal: 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: _currentIndex == key
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: _currentIndex == key
                          ? Icon(value.activeIcon)
                          : Icon(value.defaultIcon),
                    ),
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }
}
