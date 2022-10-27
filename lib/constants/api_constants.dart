import 'dart:io';

import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';

class ApiConstants {
  static const BASE_URL =
      'https://ed37-240b-10-9202-9300-ea48-00-1008.ngrok.io/api';
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
  return new Echo(
    broadcaster: EchoBroadcasterType.Pusher,
    client: getPusherClient(token),
  );
}

PusherClient getPusherClient(String token) {
  PusherOptions options = PusherOptions(
    encrypted: false,
    host: '10.0.3.2',
    cluster: 'ap1',
    auth: PusherAuth(
      'http://10.0.3.2:8000/api/broadcasting/auth',
      headers: {'Authorization': 'Bearer $token'},
    ),
  );
  return PusherClient('d71e6cbc448a4eccfeb2', options, enableLogging: true);
}

// void onConnectionStateChange(ConnectionStateChange event) {
//   print(event.currentState);
//   if (event.currentState == 'CONNECTED') {
//     print('connected');
//   } else if (event.currentState == 'DISCONNECTED') {
//     print('disconnected');
//   }
// }
