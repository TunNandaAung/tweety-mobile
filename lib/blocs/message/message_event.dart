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

class ReceiveMessage extends MessageEvent {
  final String chatId;
  final Message message;

  const ReceiveMessage({@required this.chatId, @required this.message})
      : assert(message != null);

  @override
  List<Object> get props => [chatId, message];
}

class MarkAsRead extends MessageEvent {
  final String chatId;
  final String username;

  const MarkAsRead({@required this.chatId, @required this.username})
      : assert(username != null, chatId != null);

  @override
  List<Object> get props => [chatId, username];
}

class UpdateReadAt extends MessageEvent {}
