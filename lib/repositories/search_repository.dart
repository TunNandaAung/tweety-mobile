import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/services/search_api_client.dart';
import 'package:meta/meta.dart';

class SearchRepository {
  final SearchApiClient searchApiClient;

  SearchRepository({@required this.searchApiClient})
      : assert(searchApiClient != null);

  Future<List<User>> searchUsers(String query) async {
    return searchApiClient.searchUsers(query);
  }
}
