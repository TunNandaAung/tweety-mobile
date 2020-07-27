import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tweety_mobile/blocs/followers_list/followers_list_bloc.dart';
import 'package:tweety_mobile/blocs/following_list/following_list_bloc.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/repositories/follow_repository.dart';
import 'package:tweety_mobile/screens/profile/follow_list_screen.dart';
import 'package:tweety_mobile/services/follow_api_client.dart';

class FollowListWrapper extends StatelessWidget {
  final User user;
  const FollowListWrapper({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FollowRepository followRepository = FollowRepository(
      followApiClient: FollowApiClient(httpClient: http.Client()),
    );
    return MultiBlocProvider(
      providers: [
        BlocProvider<FollowingListBloc>(
          create: (context) =>
              FollowingListBloc(followRepository: followRepository),
        ),
        BlocProvider<FollowersListBloc>(
          create: (context) =>
              FollowersListBloc(followRepository: followRepository),
        ),
      ],
      child: FollowListScreen(
        profileUser: user,
      ),
    );
  }
}
