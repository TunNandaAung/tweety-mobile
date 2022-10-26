import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:tweety_mobile/models/api_notification.dart';
import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/preferences/preferences.dart';

class NotificationApiClient {
  static const baseUrl = ApiConstants.BASE_URL;

  final http.Client httpClient;

  NotificationApiClient({http.Client? httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<int> fetchNotificationsCount() async {
    final url = '$baseUrl/notification-counts';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Invalid Credentials');
    }

    final notificationsCount =
        jsonDecode(response.body)['data']['notification_counts'] as int;
    print(notificationsCount);
    return notificationsCount;
  }

  Future<List<ApiNotification>> fetchNotifications() async {
    final url = '$baseUrl/notifications';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          Uri.parse(url),
          headers: requestHeaders(token!),
        );
    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Invalid Credentials');
    }

    final notificationsJson = jsonDecode(response.body)['data'] as List;
    return notificationsJson
        .map((notification) => ApiNotification.fromJson(notification))
        .toList();
  }
}
