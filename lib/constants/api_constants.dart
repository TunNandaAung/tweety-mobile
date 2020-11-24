import 'dart:io';

import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:laravel_echo/laravel_echo.dart';

class ApiConstants {
  static const BASE_URL = 'http://tweety.sharedwithexpose.com/api';
}

Map<String, String> requestHeaders(String token) {
  return {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
}

/*Had to use localhost (10.0.3.2 for Genymotion, 10.0.2.2 for official emulator) 
  because websocket port 6001 cannot be setup on expose or ngrok. 
*/
Echo echoSetup(token, pusherClient) {
  return new Echo({
    'broadcaster': 'pusher',
    'client': pusherClient,
    "wsHost": '10.0.3.2',
    "httpHost": '10.0.3.2',
    "wsPort": 6001,
    'auth': {
      "headers": {'Authorization': 'Bearer $token'}
    },
    'authEndpoint': 'http://10.0.3.2:8000/api/broadcasting/auth',
    "disableStats": true,
    "forceTLS": false,
    "enabledTransports": ['ws', 'wss']
  });
}

FlutterPusher getPusherClient(String token) {
  PusherOptions options = PusherOptions(
      encrypted: false,
      host: '10.0.3.2',
      cluster: 'ap1',
      port: 6001,
      auth: PusherAuth('http://10.0.3.2:8000/api/broadcasting/auth',
          headers: {'Authorization': 'Bearer $token'}));
  return FlutterPusher('d71e6cbc448a4eccfeb2', options, enableLogging: true);
}

void onConnectionStateChange(ConnectionStateChange event) {
  print(event.currentState);
  if (event.currentState == 'CONNECTED') {
    print('connected');
  } else if (event.currentState == 'DISCONNECTED') {
    print('disconnected');
  }
}
