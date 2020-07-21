part of 'notification_bloc.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationIinitiated extends NotificationState {}

class NotificationError extends NotificationState {}

class NotificationCountLoading extends NotificationState {}

class NotificationCountsLoaded extends NotificationState {
  final int notificationCounts;

  const NotificationCountsLoaded({@required this.notificationCounts})
      : assert(notificationCounts != null);

  @override
  List<Object> get props => [notificationCounts];
}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<ApiNotification> notifications;

  const NotificationsLoaded({@required this.notifications})
      : assert(notifications != null);

  @override
  List<Object> get props => [notifications];
}
