import 'package:flutter/material.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/widgets/tweet_card.dart';

class TweetScreen extends StatefulWidget {
  final Tweet tweet;
  const TweetScreen({Key key, this.tweet}) : super(key: key);

  @override
  _TweetScreenState createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            'Tweet',
            style: Theme.of(context).appBarTheme.textTheme.caption,
          ),
          centerTitle: true,
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
          ),
        ),
        body: NestedScrollView(
          controller: _scrollController,
          physics: ScrollPhysics(parent: PageScrollPhysics()),
          headerSliverBuilder: (context, innderBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 10.0),
                  child: TweetCard(
                    tweet: widget.tweet,
                  ),
                ),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              SizedBox(height: 5.0),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Center(
                      child: Text("REPLIES"),
                    )),
              ),
            ],
          ),
        ));
  }
}
