import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:tweety_mobile/blocs/profile_tweet/profile_tweet_bloc.dart';
import 'package:tweety_mobile/repositories/tweet_repository.dart';
import 'package:tweety_mobile/screens/profile_screen.dart';
import 'package:tweety_mobile/services/tweet_api_client.dart';

class ProfileWrapper extends StatelessWidget {
  const ProfileWrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final client = http.Client();
    final username = ModalRoute.of(context).settings.arguments;

    // final UserRepository userRepository = UserRepository(
    //   userApiClient: UserApiClient(httpClient: client),
    // );

    final TweetRepository tweetRepository = TweetRepository(
      tweetApiClient: TweetApiClient(httpClient: client),
    );

    return MultiBlocProvider(
      providers: [
        // BlocProvider<ProfileBloc>(
        //   create: (context) => ProfileBloc(userRepository: userRepository),
        // ),
        BlocProvider<ProfileTweetBloc>(
          create: (context) =>
              ProfileTweetBloc(tweetRepository: tweetRepository),
        ),
      ],
      child: ProfileScreen(username: username),
    );
  }
}
