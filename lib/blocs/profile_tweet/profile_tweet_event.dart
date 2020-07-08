part of 'profile_tweet_bloc.dart';

abstract class ProfileTweetEvent extends Equatable {
  const ProfileTweetEvent();
}

class FetchProfileTweet extends ProfileTweetEvent {
  final String username;

  const FetchProfileTweet({@required this.username});

  @override
  List<Object> get props => [];
}

class RefreshProfileTweet extends ProfileTweetEvent {
  final String username;

  const RefreshProfileTweet({@required this.username});
  @override
  List<Object> get props => [];
}
