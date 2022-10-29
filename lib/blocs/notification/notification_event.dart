part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class InitPushNotification extends NotificationEvent {
  final BuildContext context;

  const InitPushNotification(this.context);

  @override
  List<Object> get props => [context];
}

class FetchNotificationsCount extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class ResetNotificationsCount extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class FetchNotifications extends NotificationEvent {
  @override
  List<Object> get props => [];
}
