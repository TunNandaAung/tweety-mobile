import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tweety_mobile/blocs/notification/notification_bloc.dart';

class NotificationButton extends StatefulWidget {
  final Color? bubbleColor;
  final Icon icon;

  const NotificationButton({Key? key, this.bubbleColor, required this.icon})
      : super(key: key);

  @override
  NotificationButtonState createState() => NotificationButtonState();
}

class NotificationButtonState extends State<NotificationButton> {
  @override
  void initState() {
    context.read<NotificationBloc>().add(FetchNotificationsCount());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.icon,
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationsCountLoaded &&
                state.notificationsCount > 0) {
              return Positioned(
                left: 11.0,
                top: 0.0,
                child: Container(
                  height: 15.0,
                  width: 15.0,
                  decoration: BoxDecoration(
                    color: widget.bubbleColor ?? Colors.white.withOpacity(.4),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      '${state.notificationsCount}',
                      style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox(height: 0, width: 0);
          },
        )
      ],
    );
  }
}
