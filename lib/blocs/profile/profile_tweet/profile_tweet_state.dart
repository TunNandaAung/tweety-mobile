part of 'profile_tweet_bloc.dart';

@immutable
abstract class ProfileTweetState extends Equatable {
  const ProfileTweetState();

  @override
  List<Object> get props => [];
}

class ProfileTweetInitial extends ProfileTweetState {}

class ProfileTweetLoading extends ProfileTweetState {}

class ProfileTweetLoaded extends ProfileTweetState {
  final List<Tweet> tweets;
  final bool hasReachedMax;
  final int pageNumber;

  const ProfileTweetLoaded(
      {@required this.tweets, this.hasReachedMax, this.pageNumber = 1})
      : assert(tweets != null);

  ProfileTweetLoaded copyWith({
    List<Tweet> tweets,
    bool hasReachedMax,
    int pageNumber,
  }) {
    return ProfileTweetLoaded(
      tweets: tweets ?? this.tweets,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object> get props => [tweets, hasReachedMax, pageNumber];

  @override
  String toString() =>
      'ProfileTweetLoaded { tweets: ${tweets.length}, hasReachedMax: $hasReachedMax }';
}

class ProfileTweetError extends ProfileTweetState {}
