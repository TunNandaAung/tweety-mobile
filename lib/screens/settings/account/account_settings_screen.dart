import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/auth_profile/auth_profile_bloc.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/screens/settings/account/update_email.dart';
import 'package:tweety_mobile/screens/settings/account/update_password.dart';
import 'package:tweety_mobile/widgets/list_tiles/settings_list_tile.dart';

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
          color: Theme.of(context).appBarTheme.iconTheme.color,
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
      body: BlocListener<AuthProfileBloc, AuthProfileState>(
        listener: (context, state) {
          if (state is AuthProfileInfoUpdateSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor: Theme.of(context).primaryColor,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Email successfully updated!"),
                    ],
                  ),
                ),
              );
          }
          if (state is AuthProfilePasswordUpdateSuccess) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor: Theme.of(context).primaryColor,
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Password successfully updated!"),
                    ],
                  ),
                ),
              );
          }
        },
        child: BlocBuilder<AuthProfileBloc, AuthProfileState>(
          builder: (context, state) {
            var user = (state is AuthProfileLoaded) ? state.user : widget.user;
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              children: <Widget>[
                settingsListTile(
                  context,
                  'Email',
                  user: user,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdateEmailScreen(
                          user: user,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.0),
                settingsListTile(
                  context,
                  'Password',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UpdatePasswordScreen(),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
