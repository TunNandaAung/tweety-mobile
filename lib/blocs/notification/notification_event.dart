part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class InitPushNotification extends NotificationEvent {
  final BuildContext context;

  InitPushNotification(this.context);

  @override
  List<Object> get props => [context];
}

class FetchNotificationCounts extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class ResetNotificationCounts extends NotificationEvent {
  @override
  List<Object> get props => [];
}

class FetchNotifications extends NotificationEvent {
  @override
  List<Object> get props => [];
}
