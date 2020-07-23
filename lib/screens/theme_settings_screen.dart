import 'package:flutter/material.dart';

class ThemeSettingsScreen extends StatefulWidget {
  ThemeSettingsScreen({Key key}) : super(key: key);

  @override
  _ThemeSettingsScreenState createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  bool toggleValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Hero(
          tag: 'settings__theme',
          child: Text(
            'Theme',
            style: Theme.of(context).appBarTheme.textTheme.caption,
          ),
        ),
        centerTitle: true,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
        ),
      ),
      body: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: 30.0,
          width: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: toggleValue
                ? Colors.greenAccent[100]
                : Colors.redAccent[100].withOpacity(0.5),
          ),
          child: Stack(
            children: <Widget>[
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
                top: 3.0,
                left: toggleValue ? 30.0 : 0.0,
                right: toggleValue ? 0.0 : 30.0,
                child: InkWell(
                  onTap: _toggleButton,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(
                        child: child,
                        scale: animation,
                      );
                    },
                    child: toggleValue
                        ? Icon(Icons.check_circle,
                            color: Colors.green, size: 25.0, key: UniqueKey())
                        : Icon(Icons.remove_circle_outline,
                            color: Colors.red, size: 25.0, key: UniqueKey()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleButton() {
    setState(() {
      toggleValue = !toggleValue;
    });
  }
}
