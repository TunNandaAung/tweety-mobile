import 'package:equatable/equatable.dart';

class LikeDislike extends Equatable {
  final bool liked;
  final bool disliked;
  final bool removed;

  const LikeDislike({this.liked, this.disliked, this.removed});

  @override
  List<Object> get props => [
        liked,
        disliked,
        removed,
      ];

  static LikeDislike fromJson(dynamic json) {
    final data = json['data'];
    return LikeDislike(
      liked: data['liked'] as bool,
      disliked: data['disliked'] as bool,
      removed: data['removed'] as bool,
    );
  }
}
