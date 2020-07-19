import 'package:flutter/material.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/screens/change_email.dart';
import 'package:tweety_mobile/widgets/settings_list_tile.dart';

class AccountSettingsScreen extends StatefulWidget {
  final User user;

  AccountSettingsScreen({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: BackButton(
            color: Colors.black,
          ),
          title: Hero(
            tag: 'settings__account',
            child: Text(
              'Account',
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
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          children: <Widget>[
            settingsListTile(
              context,
              'Email',
              user: widget.user,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChangeEmailScreen(
                      user: widget.user,
                    ),
                  ),
                );
              },
            ),
          ],
        ));
  }
}
