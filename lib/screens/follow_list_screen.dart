import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FollowListScreen extends StatefulWidget {
  FollowListScreen({Key key}) : super(key: key);

  @override
  _FollowListScreenState createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {
  bool shouldAddSafeArea = false;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    // _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    // BlocProvider.of<ProductBloc>(context).add(
    //   FetchProduct(companyID: widget.company.id),
    // );
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      print('Forward');
      setState(() {
        shouldAddSafeArea = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        shouldAddSafeArea = true;
      });
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
                      'User',
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
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  key: PageStorageKey('tab1'),
                  itemCount: 100,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Item $index'),
                    );
                  },
                ),
                ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 5.0),
                  key: PageStorageKey('tab2'),
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
