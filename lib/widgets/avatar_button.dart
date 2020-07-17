import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/auth_profile/auth_profile_bloc.dart';

class AvatarButton extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  AvatarButton({Key key, this.scaffoldKey}) : super(key: key);

  @override
  _AvatarButtonState createState() => _AvatarButtonState();
}

class _AvatarButtonState extends State<AvatarButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: () => widget.scaffoldKey.currentState.openDrawer(),
        child: BlocBuilder<AuthProfileBloc, AuthProfileState>(
          builder: (context, state) {
            if (state is AvatarLoaded) {
              return CircleAvatar(
                radius: 15.0,
                backgroundColor: Theme.of(context).cardColor,
                backgroundImage: NetworkImage(state.avatar),
              );
            }

            if (state is AuthProfileLoaded) {
              return CircleAvatar(
                radius: 15.0,
                backgroundColor: Theme.of(context).cardColor,
                backgroundImage: NetworkImage(state.user.avatar),
              );
            }
            return CircleAvatar(
              radius: 15.0,
              backgroundColor: Theme.of(context).cardColor,
            );
          },
        ),
      ),
    );
  }
}
