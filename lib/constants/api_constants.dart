import 'dart:io';

class ApiConstants {
  static const BASE_URL = 'http://6fe0d32be1c1.ngrok.io/api';
}

Map<String, String> requestHeaders(String token) {
  return {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
}
