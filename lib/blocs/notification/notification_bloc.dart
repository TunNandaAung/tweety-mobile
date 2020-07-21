import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tweety_mobile/repositories/notification_repository.dart';
import 'package:tweety_mobile/models/api_notification.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  // final PushNotificationRepository pushNotificationRepository;
  final NotificationRepository notificationRepository;

  NotificationBloc({@required this.notificationRepository})
      : assert(notificationRepository != null),
        super(NotificationInitial());

  @override
  Stream<NotificationState> mapEventToState(
    NotificationEvent event,
  ) async* {
    if (event is FetchNotificationCounts) {
      yield* _mapFetchNotificationCountsToState(event);
    } else if (event is ResetNotificationCounts) {
      yield* _mapResetNotificationCountsToState(event);
    } else if (event is FetchNotifications) {
      yield* _mapFetchNotificationsToState(event);
    }
  }

  // Stream<NotificationState> _mapInitPushNotificationToState(event) async* {
  //   try {
  //     pushNotificationRepository.init();
  //   } catch (_) {}
  // }

  Stream<NotificationState> _mapFetchNotificationCountsToState(event) async* {
    // final currentState = state;
    // if (!(currentState is NotificationCountsLoaded)) {
    //   try {
    //     final notificationCounts =
    //         await notificationRepository.getNotificationCounts();
    //     yield NotificationCountLoading();

    //     yield NotificationCountsLoaded(notificationCounts: notificationCounts);
    //   } catch (_) {
    //     yield NotificationError();
    //   }
    // } else
    //   yield currentState;
    yield NotificationCountLoading();
    try {
      final notificationCounts =
          await notificationRepository.getNotificationCounts();

      yield NotificationCountsLoaded(notificationCounts: notificationCounts);
    } catch (_) {
      yield NotificationError();
    }
  }

  Stream<NotificationState> _mapResetNotificationCountsToState(event) async* {
    yield NotificationCountLoading();
    final currentState = state;
    if (currentState is NotificationCountsLoaded) {
      try {
        yield NotificationCountsLoaded(notificationCounts: 0);
      } catch (_) {
        yield NotificationError();
      }
    }
  }

  Stream<NotificationState> _mapFetchNotificationsToState(event) async* {
    yield NotificationLoading();
    try {
      final notifications = await notificationRepository.getNotifications();
      yield NotificationsLoaded(notifications: notifications);
    } catch (_) {
      yield NotificationError();
    }
  }
}
