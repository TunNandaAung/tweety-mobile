import 'package:tweety_mobile/models/api_notification.dart';
import 'package:tweety_mobile/services/notification_api_client.dart';

class NotificationRepository {
  final NotificationApiClient notificationApiClient;

  NotificationRepository({NotificationApiClient notificationApiClient})
      : notificationApiClient =
            notificationApiClient ?? NotificationApiClient();

  Future<int> getNotificationsCount() async {
    return notificationApiClient.fetchNotificationsCount();
  }

  Future<List<ApiNotification>> getNotifications() async {
    return notificationApiClient.fetchNotifications();
  }
}
