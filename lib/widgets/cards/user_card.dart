import 'package:flutter/material.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/widgets/buttons/follow_button.dart';

class UserCard extends StatelessWidget {
  final User user;
  const UserCard({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 5.0,
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/profile', arguments: user.username);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 5.0,
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(8.0),
              leading: CircleAvatar(
                radius: 25.0,
                backgroundImage: NetworkImage(
                  user.avatar,
                ),
                backgroundColor: Theme.of(context).cardColor,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: user.name,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Text(
                        '@' + user.username,
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    ],
                  ),
                  FollowButton(user: user),
                ],
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.description ?? '',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
