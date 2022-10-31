import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/theme/app_theme.dart';
import 'package:tweety_mobile/theme/cubit/theme_cubit.dart';

class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({Key? key}) : super(key: key);

  @override
  ThemeSettingsScreenState createState() => ThemeSettingsScreenState();
}

class ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  bool isCurrentThemeDark = Prefer.prefs.getInt('theme') == 1;
  bool isUsingSystemTheme = Prefer.prefs.getBool('use_system_theme') ?? false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(
          color: Theme.of(context).appBarTheme.iconTheme!.color,
        ),
        title: Hero(
          tag: 'settings__theme',
          child: Text(
            'Theme',
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).canvasColor,
                    offset: const Offset(0, 10),
                    blurRadius: 10,
                  )
                ]),
            child: ListTile(
              title: Text('Dark Theme',
                  style: Theme.of(context).textTheme.caption),
              trailing: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 30.0,
                width: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: isCurrentThemeDark
                      ? Colors.greenAccent[100]
                      : Colors.redAccent[100]!.withOpacity(0.5),
                ),
                child: Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      top: 3.0,
                      left: isCurrentThemeDark ? 30.0 : 0.0,
                      right: isCurrentThemeDark ? 0.0 : 30.0,
                      child: InkWell(
                        onTap: _toggleButton,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: isCurrentThemeDark
                              ? Icon(Icons.check_circle,
                                  color: Colors.green,
                                  size: 25.0,
                                  key: UniqueKey())
                              : Icon(Icons.remove_circle_outline,
                                  color: Colors.red,
                                  size: 25.0,
                                  key: UniqueKey()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).canvasColor,
                    offset: const Offset(0, 10),
                    blurRadius: 10,
                  )
                ]),
            child: ListTile(
              title: Text('Use device Settings',
                  style: Theme.of(context).textTheme.caption),
              trailing: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 30.0,
                width: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: isUsingSystemTheme
                      ? Colors.greenAccent[100]
                      : Colors.redAccent[100]!.withOpacity(0.5),
                ),
                child: Stack(
                  children: <Widget>[
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn,
                      top: 3.0,
                      left: isUsingSystemTheme ? 30.0 : 0.0,
                      right: isUsingSystemTheme ? 0.0 : 30.0,
                      child: InkWell(
                        onTap: _toggleSystemThemeButton,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: isUsingSystemTheme
                              ? Icon(Icons.check_circle,
                                  color: Colors.green,
                                  size: 25.0,
                                  key: UniqueKey())
                              : Icon(Icons.remove_circle_outline,
                                  color: Colors.red,
                                  size: 25.0,
                                  key: UniqueKey()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleButton() {
    setState(() {
      isCurrentThemeDark = !isCurrentThemeDark;
    });

    isCurrentThemeDark
        ? context.read<ThemeCubit>().changeTheme(AppTheme.Dark)
        : context.read<ThemeCubit>().changeTheme(AppTheme.Light);
  }

  void _toggleSystemThemeButton() {
    Prefer.prefs.setBool('use_system_theme', !isUsingSystemTheme);
    setState(() {
      isUsingSystemTheme = !isUsingSystemTheme;
    });

    if (WidgetsBinding.instance.window.platformBrightness == Brightness.dark) {
      context.read<ThemeCubit>().changeTheme(AppTheme.Dark);
      setState(() {
        isCurrentThemeDark = true;
      });
    } else {
      context.read<ThemeCubit>().changeTheme(AppTheme.Light);
    }
  }
}
