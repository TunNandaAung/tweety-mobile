import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/profile/profile_bloc.dart';
import 'package:tweety_mobile/models/navigation.dart';
import 'package:tweety_mobile/widgets/loading_indicator.dart';
import 'package:tweety_mobile/widgets/nav_item.dart';

class NavDrawer extends StatefulWidget {
  final String currentRoute;
  const NavDrawer(this.currentRoute);

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  int currentSelectedIndex = -1;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(
      FetchProfile(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Drawer(
      child: Container(
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: EdgeInsets.only(
              top: size.height * 0.04,
              left: size.width * 0.01,
              right: size.width * 0.01,
              bottom: size.height * 0.03),
          child: Column(
            children: <Widget>[
              BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
                if (state is ProfileLoaded) {
                  return new UserAccountsDrawerHeader(
                    accountName: Text(state.user.name,
                        style: TextStyle(color: Colors.black, fontSize: 18.0)),
                    accountEmail: Text(
                      '@' + state.user.username,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: Container(
                        width: 90.0,
                        height: 90.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(state.user.avatar),
                            fit: BoxFit.contain,
                          ),
                          border: Border.all(
                            color: Colors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.2),
                            offset: Offset(10, 10),
                            blurRadius: 12),
                      ],
                    ),
                  );
                }
                return Container(
                  height: 180.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(10, 15),
                        blurRadius: 20.0,
                      ),
                    ],
                  ),
                  child: LoadingIndicator(size: 20.0),
                );
              }),
              Expanded(
                flex: 1,
                child: ListView.separated(
                  separatorBuilder: (context, counter) {
                    return SizedBox(height: 10.0);
                  },
                  itemBuilder: (context, counter) {
                    return navigationItem(
                      context,
                      onTap: () async {
                        setState(() {
                          currentSelectedIndex = counter;
                        });
                        // Navigator.pushNamed(
                        //     context, '/${navItems[counter].title}');
                      },
                      title: navItems[counter].title,
                      icon: navItems[counter].icon,
                      iconColor: Theme.of(context).hintColor,
                      textStyle: navItemStyle,
                    );
                  },
                  itemCount: navItems.length,
                ),
              ),
              Column(
                children: <Widget>[
                  SizedBox(height: 5.0),
                  navigationItem(
                    context,
                    title: 'Log out',
                    icon: Icons.exit_to_app,
                    boxColor: Colors.white,
                    iconColor: Theme.of(context).hintColor,
                    textStyle: navItemStyle,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
