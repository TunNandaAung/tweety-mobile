import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/like_dislike.dart';
import 'package:tweety_mobile/preferences/preferences.dart';

class LikeDislikeApiClient {
  static const baseUrl = ApiConstants.BASE_URL;
  final http.Client httpClient;

  LikeDislikeApiClient({@required this.httpClient})
      : assert(httpClient != null);

  Future<LikeDislike> like(int id, String subject) async {
    final url = '$baseUrl/$subject/$id/like';
    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.post(
          url,
          headers: requestHeaders(token),
        );

    if (response.statusCode != 200) {
      throw Exception('Error liking tweet.');
    }

    final responseJson = jsonDecode(response.body);

    return LikeDislike.fromJson(responseJson);
  }
}
