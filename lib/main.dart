import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tweety_mobile/blocs/auth/authentication/authentication_bloc.dart';
import 'package:tweety_mobile/blocs/explore/explore_bloc.dart';
import 'package:tweety_mobile/blocs/follow/follow_bloc.dart';
import 'package:tweety_mobile/blocs/mention/mention_bloc.dart';
import 'package:tweety_mobile/blocs/notification/notification_bloc.dart';
import 'package:tweety_mobile/blocs/profile/profile/profile_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/blocs/auth_profile/auth_profile_bloc.dart';
import 'package:tweety_mobile/blocs/simple_bloc_observer.dart';
import 'package:tweety_mobile/blocs/search/tweet_search/tweet_search_bloc.dart';
import 'package:tweety_mobile/blocs/search/user_search/user_search_bloc.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/follow_repository.dart';
import 'package:tweety_mobile/repositories/notification_repository.dart';
import 'package:tweety_mobile/repositories/search_repository.dart';
import 'package:tweety_mobile/repositories/tweet_repository.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';
import 'package:tweety_mobile/screens/auth/forgot_password_screen.dart';
import 'package:tweety_mobile/screens/main/home_screen.dart';
import 'package:tweety_mobile/screens/auth/login_screen.dart';
import 'package:tweety_mobile/screens/profile/profile_wrapper.dart';
import 'package:tweety_mobile/screens/publish_tweet_screen.dart';
import 'package:tweety_mobile/screens/auth/register_screen.dart';
import 'package:tweety_mobile/screens/reply/reply_wrapper.dart';
import 'package:tweety_mobile/screens/settings/settings_screen.dart';
import 'package:tweety_mobile/screens/splash_screen.dart';
import 'package:tweety_mobile/screens/tweet/tweet_wrapper.dart';
import 'package:tweety_mobile/theme/app_theme.dart';
import 'package:tweety_mobile/theme/bloc/theme_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  int initialThemeIndex =
      WidgetsBinding.instance.window.platformBrightness == Brightness.light
          ? 0
          : 1;

  Prefer.prefs = await SharedPreferences.getInstance();
  Prefer.themeIndexPref = Prefer.prefs.getInt('theme') ?? initialThemeIndex;

  final UserRepository userRepository = UserRepository();

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider<TweetBloc>(
          create: (context) => TweetBloc(
            tweetRepository: TweetRepository(),
          ),
        ),
        BlocProvider<AuthProfileBloc>(
          create: (context) =>
              AuthProfileBloc(userRepository: widget.userRepository),
        ),
        BlocProvider<ExploreBloc>(
          create: (context) =>
              ExploreBloc(userRepository: widget.userRepository),
        ),
        BlocProvider<FollowBloc>(
          create: (context) => FollowBloc(followRepository: FollowRepository()),
        ),
        BlocProvider<ProfileBloc>(
          create: (context) =>
              ProfileBloc(userRepository: widget.userRepository),
        ),
        BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(
              notificationRepository: NotificationRepository()),
        ),
        BlocProvider<UserSearchBloc>(
          create: (context) =>
              UserSearchBloc(searchRepository: SearchRepository()),
        ),
        BlocProvider<TweetSearchBloc>(
          create: (context) =>
              TweetSearchBloc(searchRepository: SearchRepository()),
        ),
        BlocProvider<MentionBloc>(
          create: (context) =>
              MentionBloc(userRepository: widget.userRepository),
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
            '/register': (context) =>
                RegisterScreen(userRepository: widget.userRepository),
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
