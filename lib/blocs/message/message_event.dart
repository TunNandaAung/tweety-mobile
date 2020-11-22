part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class FetchMessages extends MessageEvent {
  final String chatId;

  FetchMessages({@required this.chatId}) : assert(chatId != null);

  @override
  List<Object> get props => [chatId];
}

class SendMessage extends MessageEvent {
  final String chatId;
  final String message;

  const SendMessage({@required this.chatId, @required this.message})
      : assert(message != null);

  @override
  List<Object> get props => [chatId, message];
}
