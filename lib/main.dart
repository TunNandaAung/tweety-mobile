import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tweety_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:tweety_mobile/blocs/explore/explore_bloc.dart';
import 'package:tweety_mobile/blocs/follow/follow_bloc.dart';
import 'package:tweety_mobile/blocs/mention/mention_bloc.dart';
import 'package:tweety_mobile/blocs/notification/notification_bloc.dart';
import 'package:tweety_mobile/blocs/profile/profile_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/blocs/auth_profile/auth_profile_bloc.dart';
import 'package:tweety_mobile/blocs/simple_bloc_observer.dart';
import 'package:tweety_mobile/blocs/tweet_search/tweet_search_bloc.dart';
import 'package:tweety_mobile/blocs/user_search/user_search_bloc.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/follow_repository.dart';
import 'package:tweety_mobile/repositories/notification_repository.dart';
import 'package:tweety_mobile/repositories/search_repository.dart';
import 'package:tweety_mobile/repositories/tweet_repository.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';
import 'package:tweety_mobile/screens/forgot_password_screen.dart';
import 'package:tweety_mobile/screens/home_screen.dart';
import 'package:tweety_mobile/screens/login_screen.dart';
import 'package:tweety_mobile/screens/profile_wrapper.dart';
import 'package:tweety_mobile/screens/publish_tweet_screen.dart';
import 'package:tweety_mobile/screens/reply_wrapper.dart';
import 'package:tweety_mobile/screens/settings_screen.dart';
import 'package:tweety_mobile/screens/splash_screen.dart';
import 'package:tweety_mobile/screens/tweet_wrapper.dart';
import 'package:tweety_mobile/services/follow_api_client.dart';
import 'package:tweety_mobile/services/notification_api_client.dart';
import 'package:tweety_mobile/services/search_api_client.dart';
import 'package:tweety_mobile/services/tweet_api_client.dart';
import 'package:tweety_mobile/services/user_api_client.dart';
import 'package:tweety_mobile/theme/app_theme.dart';
import 'package:tweety_mobile/theme/bloc/theme_bloc.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  Prefer.prefs = await SharedPreferences.getInstance();
  Prefer.themeIndexPref = Prefer.prefs.getInt('theme') ?? 1;

  final UserRepository userRepository =
      UserRepository(userApiClient: UserApiClient(httpClient: http.Client()));

  runApp(
    BlocProvider(
        create: (context) => AuthenticationBloc(userRepository: userRepository)
          ..add(AuthenticationStarted()),
        child: Tweety(userRepository: userRepository)),
  );
}

class Tweety extends StatefulWidget {
  final UserRepository userRepository;

  const Tweety({Key key, this.userRepository}) : super(key: key);

  @override
  _TweetyState createState() => _TweetyState();
}

class _TweetyState extends State<Tweety> {
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc =
        AuthenticationBloc(userRepository: widget.userRepository);
    _authenticationBloc.add(AuthenticationStarted());
  }

  @override
  Widget build(BuildContext context) {
    final client = http.Client();
    final TweetRepository tweetRepository = TweetRepository(
      tweetApiClient: TweetApiClient(httpClient: client),
    );
    final UserRepository userRepository = UserRepository(
      userApiClient: UserApiClient(httpClient: client),
    );
    final FollowRepository followRepository = FollowRepository(
      followApiClient: FollowApiClient(httpClient: client),
    );
    final NotificationRepository notificationRepository =
        NotificationRepository(
      notificationApiClient: NotificationApiClient(httpClient: client),
    );
    final SearchRepository searchRepository = SearchRepository(
      searchApiClient: SearchApiClient(httpClient: client),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<TweetBloc>(
          create: (context) => TweetBloc(
            tweetRepository: tweetRepository,
          ),
        ),
        BlocProvider<AuthProfileBloc>(
          create: (context) => AuthProfileBloc(userRepository: userRepository),
        ),
        BlocProvider<ExploreBloc>(
          create: (context) => ExploreBloc(userRepository: userRepository),
        ),
        BlocProvider<FollowBloc>(
          create: (context) => FollowBloc(followRepository: followRepository),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(userRepository: userRepository),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) =>
              NotificationBloc(notificationRepository: notificationRepository),
        ),
        BlocProvider<UserSearchBloc>(
          create: (context) =>
              UserSearchBloc(searchRepository: searchRepository),
        ),
        BlocProvider<TweetSearchBloc>(
          create: (context) =>
              TweetSearchBloc(searchRepository: searchRepository),
        ),
        BlocProvider<MentionBloc>(
          create: (context) => MentionBloc(userRepository: userRepository),
        ),
      ],
      child: _buildWithTheme(context),
    );
  }

  Widget _buildWithTheme(BuildContext context) {
    return BlocBuilder<ThemeBloc, AppTheme>(
      builder: (context, appTheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Tweety',
          theme: appThemeData[appTheme],
          routes: {
            '/': (context) {
              return BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                if (state is AuthenticationFailure) {
                  return LoginScreen(userRepository: widget.userRepository);
                }
                if (state is AuthenticationSuccess) {
                  return HomeScreen();
                }
                return SplashScreen();
              });
            },
            '/profile': (context) => ProfileWrapper(),
            '/publish-tweet': (context) => PublishTweetScreen(),
            '/settings': (context) => SettingsScreen(),
            '/tweet-reply': (context) => ReplyWrapper(),
            '/tweet': (context) => TweetWrapper(),
            '/forgot-password': (context) => ForgotPasswordScreen(),
          },
        );
      },
    );
  }
}
