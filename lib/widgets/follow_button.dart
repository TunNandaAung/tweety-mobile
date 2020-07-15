import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/follow/follow_bloc.dart';
import 'package:tweety_mobile/models/user.dart';

class FollowButton extends StatefulWidget {
  final User user;
  FollowButton({Key key, @required this.user}) : super(key: key);

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool get _isFollowed => widget.user.isFollowed;
  set _isFollowed(bool isFollowed) => widget.user.isFollowed = isFollowed;

  @override
  Widget build(BuildContext context) {
    return _isFollowed ? _unfollowButton() : _followButton();
  }

  Widget _followButton() {
    return FlatButton(
      onPressed: () {
        _follow();
      },
      color: Colors.transparent,
      disabledColor: Colors.grey,
      padding: EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1,
            style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(30.0),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Text(
        'Follow',
        style: Theme.of(context).textTheme.button.copyWith(
              color: Theme.of(context).primaryColor,
            ),
      ),
    );
  }

  Widget _unfollowButton() {
    return FlatButton(
      onPressed: () {
        _unfollow();
      },
      color: Theme.of(context).primaryColor,
      disabledColor: Colors.grey,
      padding: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Text(
        'Following',
        style: Theme.of(context).textTheme.button,
      ),
    );
  }

  void _follow() async {
    HapticFeedback.mediumImpact();
    BlocProvider.of<FollowBloc>(context).add(FollowUser(user: widget.user));
    setState(() {
      _isFollowed = true;
    });
  }

  void _unfollow() async {
    HapticFeedback.mediumImpact();
    BlocProvider.of<FollowBloc>(context).add(UnfollowUser(user: widget.user));
    setState(() {
      _isFollowed = false;
    });
  }
}
