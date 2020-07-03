import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tweety_mobile/blocs/simple_bloc_observer.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/screens/login_form.dart';
import 'package:tweety_mobile/theme/app_theme.dart';
import 'package:tweety_mobile/theme/bloc/theme_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefer.prefs = await SharedPreferences.getInstance();
  Prefer.themeIndexPref = Prefer.prefs.getInt('theme') ?? 0;
  Bloc.observer = SimpleBlocObserver();
  runApp(Tweety());
}

class Tweety extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _TweetyState createState() => _TweetyState();
}

class _TweetyState extends State<Tweety> {
  @override
  Widget build(BuildContext context) {
    // return MultiBlocProvider(
    //   providers: [
    //     BlocProvider<ThemeBloc>(
    //       create: (context) => ThemeBloc(),
    //     ),
    //   ],
    // );
    return BlocProvider<ThemeBloc>(
      create: (context) => ThemeBloc(),
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
          home: LoginForm(),
        );
      },
    );
  }
}
