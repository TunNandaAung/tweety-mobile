import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/models/user_paginator.dart';
import 'package:tweety_mobile/services/follow_api_client.dart';

class FollowRepository {
  final FollowApiClient followApiClient;

  FollowRepository({FollowApiClient? followApiClient})
      : followApiClient = followApiClient ?? FollowApiClient();

  Future<User> toggleFollow(String username) async {
    return followApiClient.toggleFollow(username);
  }

  Future<UserPaginator> getFollowing(
      {required String username, required int pageNumber}) async {
    return followApiClient.fetchFollowing(username, pageNumber);
  }

  Future<UserPaginator> getFollowers(
      {required String username, required int pageNumber}) async {
    return followApiClient.fetchFollowers(username, pageNumber);
  }
}
