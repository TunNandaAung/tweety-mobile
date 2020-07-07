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
                  return new Container(
                    width: double.infinity,
                    height: size.height * 0.24,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.2),
                            offset: Offset(10, 10),
                            blurRadius: 12),
                        BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(.2),
                            offset: Offset(-10, -10),
                            blurRadius: 12),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.grey[100],
                            backgroundImage: NetworkImage(state.user.avatar),
                            radius: 25.0,
                          ),
                          SizedBox(height: size.height * 0.01),
                          Text(
                            state.user.name,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '@' + state.user.username,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    state.user.followsCount.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    'Following',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                              SizedBox(width: size.width * 0.03),
                              Row(
                                children: <Widget>[
                                  Text(
                                    state.user.followersCount.toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    'Follower',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }
                return Container(
                  height: size.height * 0.24,
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
                      boxColor: Theme.of(context).hintColor.withOpacity(.05),
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
