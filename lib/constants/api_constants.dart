import 'dart:io';

class ApiConstants {
  // static const BASE_URL = 'https://tweety.sharedwithexpose.com/api';
  static const BASE_URL = 'http://4cd894c13fa3.ngrok.io/api';
}

Map<String, String> requestHeaders(String token) {
  return {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.authorizationHeader: 'Bearer $token'
  };
}
