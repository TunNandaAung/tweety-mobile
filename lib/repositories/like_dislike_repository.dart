import 'package:tweety_mobile/models/like_dislike.dart';
import 'package:tweety_mobile/services/like_dislike_api_client.dart';

class LikeDislikeRepository {
  final LikeDislikeApiClient likeApiClient;

  LikeDislikeRepository({required this.likeApiClient});

  Future<LikeDislike> like({required int id, required String subject}) async {
    return likeApiClient.like(id, subject);
  }

  Future<LikeDislike> dislike(
      {required int id, required String subject}) async {
    return likeApiClient.dislike(id, subject);
  }
}
