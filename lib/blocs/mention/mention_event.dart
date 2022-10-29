part of 'mention_bloc.dart';

abstract class MentionEvent extends Equatable {
  const MentionEvent();
}

class FindMentionedUser extends MentionEvent {
  final String? query;

  const FindMentionedUser({this.query});
  @override
  List<Object> get props => [];
}

class BodyChanged extends MentionEvent {
  final String body;

  const BodyChanged({required this.body});

  @override
  List<Object> get props => [body];

  @override
  String toString() => 'BodyChanged { body :$body }';
}
