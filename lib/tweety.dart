import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/chat/chat_bloc.dart';
import 'package:tweety_mobile/repositories/chat_repository.dart';
import 'package:tweety_mobile/screens/screens.dart';
import 'package:tweety_mobile/theme/app_theme.dart';
import 'package:tweety_mobile/theme/bloc/theme_bloc.dart';
import 'package:tweety_mobile/repositories/repositories.dart';
import 'package:tweety_mobile/blocs/blocs.dart';

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
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(chatRepository: ChatRepository()),
        )
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
