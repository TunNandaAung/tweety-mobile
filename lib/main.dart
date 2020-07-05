import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tweety_mobile/blocs/authentication/authentication_bloc.dart';
import 'package:tweety_mobile/blocs/reply/reply_bloc.dart';
import 'package:tweety_mobile/blocs/tweet/tweet_bloc.dart';
import 'package:tweety_mobile/blocs/profile/profile_bloc.dart';
import 'package:tweety_mobile/blocs/simple_bloc_observer.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/repositories/reply_repository.dart';
import 'package:tweety_mobile/repositories/tweet_repository.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';
import 'package:tweety_mobile/screens/home_screen.dart';
import 'package:tweety_mobile/screens/login_screen.dart';
import 'package:tweety_mobile/screens/splash_screen.dart';
import 'package:tweety_mobile/services/reply_api_client.dart';
import 'package:tweety_mobile/services/tweet_api_client.dart';
import 'package:tweety_mobile/services/user_api_client.dart';
import 'package:tweety_mobile/theme/app_theme.dart';
import 'package:tweety_mobile/theme/bloc/theme_bloc.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  Prefer.prefs = await SharedPreferences.getInstance();
  Prefer.themeIndexPref = Prefer.prefs.getInt('theme') ?? 0;

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

    final ReplyRepository replyRepository = ReplyRepository(
      replyApiClient: ReplyApiClient(httpClient: client),
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
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(userRepository: userRepository),
        ),
        BlocProvider<ReplyBloc>(
          create: (context) => ReplyBloc(replyRepository: replyRepository),
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
          },
        );
      },
    );
  }
}
