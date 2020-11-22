import 'dart:io';

import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:tweety_mobile/preferences/preferences.dart';

class ApiConstants {
  static const BASE_URL = 'http://10.0.3.2:8000/api';
}

Map<String, String> requestHeaders(String token) {
  return {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
}

Echo echoSetup() {
  FlutterPusher pusherClient = getPusherClient();

  final token = Prefer.prefs.getString('token');

  return new Echo({
    "broadcaster": 'pusher',
    'client': pusherClient,
    'auth': {
      'headers': {'Authorization': 'Bearer $token'}
    },
    'authEndPoint': ApiConstants.BASE_URL + "/broadcasting/auth",
    "wsHost": "10.0.3.2",
    "wsPort": 6001,
    "disableStats": true,
    "forceTLS": false,
  });
}

FlutterPusher getPusherClient() {
  PusherOptions options = PusherOptions(
    encrypted: true,
  );
  return FlutterPusher('app', options, lazyConnect: true);
}
