part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class FetchMessages extends MessageEvent {
  final String chatID;

  FetchMessages({@required this.chatID}) : assert(chatID != null);

  @override
  List<Object> get props => [chatID];
}
