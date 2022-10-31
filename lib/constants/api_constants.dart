import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:laravel_echo/laravel_echo.dart';
import 'package:laravel_flutter_pusher/laravel_flutter_pusher.dart';

class ApiConstants {
  static const BASE_URL = 'http://10.0.2.2:8000/api';
}

Map<String, String> requestHeaders(String token) {
  return {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
}

/*Had to use localhost (10.0.2.2 for Genymotion, 10.0.2.2 for official emulator)
  because websocket port 6001 cannot be setup on expose or ngrok.
*/
Echo echoSetup(token, pusherClient) {
  return Echo({
    'broadcaster': 'pusher',
    'client': pusherClient,
  });
}

LaravelFlutterPusher getPusherClient(String token) {
  var options = PusherOptions(
    encrypted: false,
    host: '10.0.2.2',
    port: 6001,
    cluster: 'ap1',
    auth: PusherAuth(
      '${ApiConstants.BASE_URL}/broadcasting/auth',
      headers: {'Authorization': 'Bearer $token'},
    ),
  );
  return LaravelFlutterPusher('d71e6cbc448a4eccfeb2', options,
      enableLogging: true);
}

// void onConnectionStateChange(ConnectionStateChange event) {
//   print(event.currentState);
//   if (event.currentState == 'CONNECTED') {
//     print('connected');
//   } else if (event.currentState == 'DISCONNECTED') {
//     print('disconnected');
//   }
// }
