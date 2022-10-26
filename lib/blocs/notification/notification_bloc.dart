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

  NotificationBloc({this.notificationRepository})
      : super(NotificationInitial()) {
    on<FetchNotificationsCount>(_onFetchNotificationsCount);
    on<ResetNotificationsCount>(_onResetNotificationsCount);
    on<FetchNotifications>(_onFetchNotifications);
  }

  Future<void> _onFetchNotificationsCount(
      FetchNotificationsCount event, Emitter<NotificationState> emit) async {
    emit(NotificationCountLoading());
    try {
      final notificationsCount =
          await notificationRepository.getNotificationsCount();

      emit(NotificationsCountLoaded(notificationsCount: notificationsCount));
    } catch (_) {
      emit(NotificationError());
    }
  }

  Future<void> _onResetNotificationsCount(
      ResetNotificationsCount event, Emitter<NotificationState> emit) async {
    emit(NotificationCountLoading());
    final currentState = state;
    if (currentState is NotificationsCountLoaded) {
      try {
        emit(NotificationsCountLoaded(notificationsCount: 0));
      } catch (_) {
        emit(NotificationError());
      }
    }
  }

  Future<void> _onFetchNotifications(
      FetchNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationLoading());
    try {
      final notifications = await notificationRepository.getNotifications();
      emit(NotificationsLoaded(notifications: notifications));
    } catch (_) {
      emit(NotificationError());
    }
  }
}
