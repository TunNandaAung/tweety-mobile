import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tweety_mobile/blocs/like_dislike/like_dislike_bloc.dart';
import 'package:tweety_mobile/models/like_dislike_repository.dart';
import 'package:tweety_mobile/models/reply.dart';
import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/services/like_dislike_api_client.dart';
import 'package:tweety_mobile/utils/helpers.dart';

class LikeDislikeButtons extends StatefulWidget {
  final Tweet tweet;
  final Reply reply;
  LikeDislikeButtons({Key key, this.tweet, this.reply}) : super(key: key);

  @override
  _LikeDislikeButtonsState createState() => _LikeDislikeButtonsState();
}

class _LikeDislikeButtonsState extends State<LikeDislikeButtons> {
  final LikeDislikeRepository likeDislikeRepository = LikeDislikeRepository(
    likeApiClient: LikeDislikeApiClient(httpClient: http.Client()),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LikeDislikeBloc>(
      create: (context) =>
          LikeDislikeBloc(likeDislikeRepository: likeDislikeRepository),
      child: BuildWidget(
        tweet: widget.tweet,
        reply: widget.reply,
      ),
    );
  }
}

class BuildWidget extends StatefulWidget {
  final Tweet tweet;
  final Reply reply;
  BuildWidget({Key key, this.tweet, this.reply}) : super(key: key);

  @override
  _BuildWidgetState createState() => _BuildWidgetState();
}

class _BuildWidgetState extends State<BuildWidget> {
  get subject => widget.tweet ?? widget.reply;
  get isTweet => widget.tweet != null;

  get _isLiked => subject.isLiked;
  set _isLiked(bool isLiked) => subject.isLiked = isLiked;

  get _isDisliked => subject.isDisliked;
  set _isDisliked(bool isDisliked) => subject.isDisliked = isDisliked;

  get _likesCount => subject.likesCount;
  set _likesCount(int likesCount) => subject.likesCount = likesCount;

  get _dislikesCount => subject.dislikesCount;
  set _dislikesCount(int dislikesCount) =>
      subject.dislikesCount = dislikesCount;

  @override
  void initState() {
    super.initState();
  }

  void updateLikes() {
    setState(() {
      !_isLiked ? _likesCount++ : _likesCount--;

      _isLiked = !_isLiked;
      _isDisliked = false;

      _dislikesCount > 0 ? _dislikesCount-- : _dislikesCount;
    });
  }

  void updateDislikes() {
    setState(() {
      !_isDisliked ? _dislikesCount++ : _dislikesCount--;

      _isDisliked = !_isDisliked;
      _isLiked = false;

      _likesCount > 0 ? _likesCount-- : _likesCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LikeDislikeBloc, LikeDislikeState>(
      listener: (context, state) {
        if (state is Liked) {
          // setState(() {
          //   state.like.liked ? _likesCount++ : _likesCount--;

          //   _isLiked = !_isLiked;
          //   _isDisliked = false;

          //   _dislikesCount > 0 ? _dislikesCount-- : _dislikesCount;
          // });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _likesCount > 0
                  ? Padding(
                      padding: EdgeInsets.only(right: 3.0),
                      child: Text(
                        formatCount(_likesCount),
                        style: TextStyle(
                          color:
                              _isLiked ? Color(0xFF68D391) : Color(0xFFA0AEC0),
                        ),
                      ),
                    )
                  : Container(),
              InkWell(
                onTap: () {
                  isTweet
                      ? context.read<LikeDislikeBloc>().add(
                            Like(tweetID: subject.id, subject: 'tweets'),
                          )
                      : context.read<LikeDislikeBloc>().add(
                            Like(tweetID: subject.id, subject: 'replies'),
                          );
                  updateLikes();
                },
                child: Icon(
                  Icons.thumb_up,
                  size: 18.0,
                  color: _isLiked ? Color(0xFF68D391) : Color(0xFFA0AEC0),
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _dislikesCount > 0
                  ? Padding(
                      padding: EdgeInsets.only(right: 3.0),
                      child: Text(
                        formatCount(_dislikesCount),
                        style: TextStyle(
                          color: _isDisliked
                              ? Color(0xFFE53E3E)
                              : Color(0xFFA0AEC0),
                        ),
                      ),
                    )
                  : Container(),
              InkWell(
                onTap: () {
                  isTweet
                      ? context.read<LikeDislikeBloc>().add(
                            Dislike(tweetID: subject.id, subject: 'tweets'),
                          )
                      : context.read<LikeDislikeBloc>().add(
                            Dislike(tweetID: subject.id, subject: 'replies'),
                          );
                  updateDislikes();
                },
                child: Icon(
                  Icons.thumb_down,
                  size: 18.0,
                  color: _isDisliked ? Color(0xFFE53E3E) : Color(0xFFA0AEC0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
