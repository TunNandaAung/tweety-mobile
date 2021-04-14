import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tweety_mobile/blocs/auth_profile/auth_profile_bloc.dart';
import 'package:tweety_mobile/blocs/children_reply/children_reply_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/screens/reply/add_reply_screen.dart';
import 'package:tweety_mobile/screens/photo_view_screen.dart';
import 'package:tweety_mobile/screens/tweet/tweet_wrapper.dart';
import 'package:tweety_mobile/utils/helpers.dart';
import 'package:tweety_mobile/widgets/buttons/add_reply_button.dart';
import 'package:tweety_mobile/widgets/buttons/like_dislike_buttons.dart';
import 'package:tweety_mobile/widgets/cards/reply.dart';
import 'package:tweety_mobile/widgets/modals/tweet_actions_modal.dart';

class TweetReplyScreen extends StatefulWidget {
  final Reply reply;
  final ReplyRepository replyRepository;
  const TweetReplyScreen({Key key, @required this.reply, this.replyRepository})
      : super(key: key);

  @override
  _TweetReplyScreenState createState() => _TweetReplyScreenState();
}

class _TweetReplyScreenState extends State<TweetReplyScreen> {
  final _scrollController = ScrollController();
  List<Reply> replies = [];
  // ignore: close_sinks
  ReplyBloc _replyBloc;

  @override
  void initState() {
    _replyBloc = context.read<ReplyBloc>();
    replies.add(widget.reply);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(
          color: Theme.of(context).textSelectionTheme.cursorColor,
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
      body: MultiBlocListener(
        listeners: [
          BlocListener<ReplyBloc, ReplyState>(
            listener: (context, state) {
              if (state is ReplyAdded) {
                context.read<TweetBloc>().add(
                      UpdateReplyCount(
                        count: replies[0].tweet.repliesCount + 1,
                        tweetID: replies[0].tweet.id,
                      ),
                    );

                setState(() {
                  replies.add(state.reply);
                });

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Your reply was added!"),
                        ],
                      ),
                    ),
                  );
              } else if (state is ReplyDeleted) {
                context.read<TweetBloc>().add(
                      UpdateReplyCount(
                        count: (replies[0].tweet.repliesCount - state.count),
                        tweetID: replies[0].tweet.id,
                      ),
                    );
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: Theme.of(context).primaryColor,
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Your reply was deleted!"),
                        ],
                      ),
                    ),
                  );
              }
            },
          ),
          BlocListener<TweetBloc, TweetState>(
            listener: (context, state) {
              if (state is TweetDeleted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            // These are the slivers that show up in the "outer" scroll view.
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 5.0),
                    child: _tweetCard(replies[0].tweet),
                  ),
                ),
              ),
            ];
          },
          body: SafeArea(
            child: Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10.0,
                              offset: Offset(
                                -10,
                                -10,
                              ))
                        ]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 5.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 8.0, right: 8.0, left: 8.0, bottom: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Only relevant replies are shown',
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => TweetWrapper(
                                          tweet: replies[0].tweet,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('View All',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2
                                          .copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor)),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, index) => Container(
                                      child: MultiBlocProvider(
                                        providers: [
                                          BlocProvider<ChildrenReplyBloc>(
                                            create: (context) =>
                                                ChildrenReplyBloc(
                                              replyRepository:
                                                  widget.replyRepository,
                                            ),
                                          ),
                                          BlocProvider.value(
                                            value: context.watch<ReplyBloc>(),
                                          ),
                                        ],
                                        child: ReplyWidget(
                                          reply: replies[index],
                                          tweet: replies[0].tweet,
                                        ),
                                      ),
                                    ),
                                itemCount: replies.length),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: AddReplyButton(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: _replyBloc,
                    child: AddReplyScreen(
                      tweet: replies[0].tweet,
                    ),
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                BlocBuilder<AuthProfileBloc, AuthProfileState>(
                  builder: (context, state) {
                    if (state is AvatarLoaded) {
                      return CircleAvatar(
                        radius: 15.0,
                        backgroundColor: Theme.of(context).cardColor,
                        backgroundImage: NetworkImage(state.avatar),
                      );
                    }

                    if (state is AuthProfileLoaded) {
                      return CircleAvatar(
                        radius: 15.0,
                        backgroundColor: Theme.of(context).cardColor,
                        backgroundImage: NetworkImage(state.user.avatar),
                      );
                    }
                    return CircleAvatar(
                      radius: 15.0,
                      backgroundColor: Colors.white,
                    );
                  },
                ),
                Container(
                  width: 340.0,
                  height: 40.0,
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).canvasColor,
                        offset: Offset(0, 10),
                        blurRadius: (10.0),
                      )
                    ],
                    color: Theme.of(context).cardColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Add a reply',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tweetCard(Tweet tweet) {
    var size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).canvasColor,
            offset: Offset(10, 10),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(8.0),
            leading: InkWell(
              onTap: () => Navigator.of(context)
                  .pushNamed('/profile', arguments: tweet.user.username),
              child: CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  tweet.user.avatar,
                ),
                backgroundColor: Theme.of(context).cardColor,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.of(context)
                      .pushNamed('/profile', arguments: tweet.user.username),
                  child: Container(
                    width: size.width / 1.93,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        text: tweet.user.name + "\n",
                        style: Theme.of(context).textTheme.caption,
                        children: [
                          TextSpan(
                            text: "@${tweet.user.username}",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.keyboard_arrow_down),
                  color: Theme.of(context).textSelectionTheme.cursorColor,
                  onPressed: () =>
                      TweetActionsModal().mainBottomSheet(context, tweet),
                ),
              ],
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 20.0),
                      children: parseBody(tweet.body)
                          .map(
                            (body) => bodyTextSpan(
                                body,
                                context,
                                Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 18.0)),
                          )
                          .toList(),
                    ),
                  ),
                  tweet.image != null
                      ? Padding(
                          padding: EdgeInsets.only(top: 12.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PhotoViewScreen(
                                    title: '',
                                    actionText: '',
                                    imageProvider: NetworkImage(tweet.image),
                                    onTap: () {},
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 200.0,
                              width: 320.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Theme.of(context).canvasColor,
                                    offset: Offset(0, 5),
                                    blurRadius: 10.0,
                                  )
                                ],
                                image: DecorationImage(
                                    image: NetworkImage(tweet.image),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Divider(color: Colors.grey[300]),
                Row(
                  children: <Widget>[
                    Text(
                      DateFormat('h:mm a . d MMM, y .')
                          .format(tweet.createdAt.toLocal()),
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(90.0, 0.0, 50.0, 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: LikeDislikeButtons(
                    tweet: tweet,
                  ),
                ),
                AddReplyButton(
                  child: AddReplyButtonWidget(
                    tweet: tweet,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
