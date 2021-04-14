import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/like_dislike.dart';
import 'package:tweety_mobile/preferences/preferences.dart';

class LikeDislikeApiClient {
  static const baseUrl = ApiConstants.BASE_URL;
  final http.Client httpClient;

  LikeDislikeApiClient({http.Client httpClient})
      : httpClient = httpClient ?? http.Client();

  Future<LikeDislike> like(int id, String subject) async {
    final url = '$baseUrl/$subject/$id/like';
    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.post(
          Uri.parse(url),
          headers: requestHeaders(token),
        );

    if (response.statusCode != 200) {
      throw Exception('Error liking.');
    }

    final responseJson = jsonDecode(response.body);

    return LikeDislike.fromJson(responseJson);
  }

  Future<LikeDislike> dislike(int id, String subject) async {
    final url = '$baseUrl/$subject/$id/dislike';
    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.delete(
          Uri.parse(url),
          headers: requestHeaders(token),
        );

    if (response.statusCode != 200) {
      throw Exception('Error disliking.');
    }

    final responseJson = jsonDecode(response.body);

    return LikeDislike.fromJson(responseJson);
  }
}
