import 'package:tweety_mobile/models/tweet.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/services/search_api_client.dart';

class SearchRepository {
  final SearchApiClient searchApiClient;

  SearchRepository({SearchApiClient searchApiClient})
      : searchApiClient = searchApiClient ?? SearchApiClient();

  Future<List<User>> searchUsers(String query) async {
    return searchApiClient.searchUsers(query);
  }

  Future<List<Tweet>> searchTweets(String query) async {
    return searchApiClient.searchTweets(query);
  }
}
