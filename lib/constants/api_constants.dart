import 'dart:io';

class ApiConstants {
  static const BASE_URL = 'https://72a51a70d5e4.ngrok.io/api';
}

Map<String, String> requestHeaders(String token) {
  return {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
}
