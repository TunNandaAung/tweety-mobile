import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/services/follow_api_client.dart';

class FollowRepository {
  final FollowApiClient followApiClient;

  FollowRepository({@required this.followApiClient})
      : assert(followApiClient != null);

  Future<User> toggleFollow(String username) async {
    return followApiClient.toggleFollow(username);
  }
}
