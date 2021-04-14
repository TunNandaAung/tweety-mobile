import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tweety_mobile/blocs/auth_profile/auth_profile_bloc.dart';
import 'package:tweety_mobile/blocs/children_reply/children_reply_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/screens/reply/add_reply_screen.dart';
import 'package:tweety_mobile/screens/photo_view_screen.dart';
import 'package:tweety_mobile/utils/helpers.dart';
import 'package:tweety_mobile/widgets/buttons/add_reply_button.dart';
import 'package:tweety_mobile/widgets/buttons/like_dislike_buttons.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/refresh.dart';
import 'package:tweety_mobile/widgets/cards/reply.dart';
import 'package:tweety_mobile/widgets/modals/tweet_actions_modal.dart';

class TweetScreen extends StatefulWidget {
  final Tweet tweet;
  final ReplyRepository replyRepository;
  const TweetScreen({Key key, this.tweet, this.replyRepository})
      : super(key: key);

  @override
  _TweetScreenState createState() => _TweetScreenState();
}

class _TweetScreenState extends State<TweetScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  // ignore: close_sinks
  ReplyBloc _replyBloc;

  @override
  void initState() {
    context.read<ReplyBloc>().add(
          FetchReply(tweetID: widget.tweet.id),
        );
    _scrollController.addListener(_onScroll);
    _replyBloc = context.read<ReplyBloc>();

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      context.read<ReplyBloc>().add(
            FetchReply(tweetID: widget.tweet.id),
          );
    }
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
                        count: widget.tweet.repliesCount + 1,
                        tweetID: widget.tweet.id,
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
                          Text("Your reply was added!"),
                        ],
                      ),
                    ),
                  );
              } else if (state is ReplyDeleted) {
                context.read<TweetBloc>().add(
                      UpdateReplyCount(
                        count: (widget.tweet.repliesCount - state.count),
                        tweetID: widget.tweet.id,
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
                    child: _tweetCard(widget.tweet),
                  ),
                ),
              ),
            ];
          },
          body: SafeArea(
            top: false,
            bottom: false,
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
                    child: CustomScrollView(
                      key: PageStorageKey<String>(widget.tweet.body),
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                        ),
                        BlocBuilder<ReplyBloc, ReplyState>(
                          builder: (context, state) {
                            if (state is ReplyError) {
                              return SliverToBoxAdapter(
                                child: Container(
                                  child: Refresh(
                                    title: 'Couldn\'t load replies',
                                    onPressed: () {
                                      context.read<ReplyBloc>().add(
                                            RefreshReply(
                                                tweetID: widget.tweet.id),
                                          );
                                    },
                                  ),
                                ),
                              );
                            }
                            if (state is ReplyLoaded) {
                              if (state.replies.isEmpty) {
                                return SliverFillRemaining(
                                  child: Center(
                                    child: Text('No replies yet!',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1),
                                  ),
                                );
                              }
                              return SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => index >=
                                          state.replies.length
                                      ? LoadingIndicator()
                                      : Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8.0,
                                            vertical: 5.0,
                                          ),
                                          child: Container(
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
                                                  value: context
                                                      .watch<ReplyBloc>(),
                                                ),
                                              ],
                                              child: ReplyWidget(
                                                reply: state.replies[index],
                                                tweet: widget.tweet,
                                              ),
                                            ),
                                          ),
                                        ),
                                  childCount: state.hasReachedMax
                                      ? state.replies.length
                                      : state.replies.length + 1,
                                ),
                              );
                            }
                            return SliverFillRemaining(
                              child: Center(
                                child: LoadingIndicator(),
                              ),
                            );
                          },
                        ),
                      ],
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
                      tweet: widget.tweet,
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
