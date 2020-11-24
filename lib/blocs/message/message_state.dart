part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

class MessageInitial extends MessageState {}

class ReplyLoading extends MessageState {}

class MessageLoaded extends MessageState {
  final List<Message> messages;
  final bool hasReachedMax;
  final int pageNumber;

  const MessageLoaded(
      {@required this.messages, this.hasReachedMax, this.pageNumber = 1})
      : assert(messages != null);

  MessageLoaded copyWith({
    List<Message> messages,
    bool hasReachedMax,
    int pageNumber,
  }) {
    return MessageLoaded(
      messages: messages ?? this.messages,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object> get props => [messages, hasReachedMax, pageNumber];

  @override
  String toString() =>
      'MessageLoaded { messages: ${messages.length}, hasReachedMax: $hasReachedMax }';
}

class MessageError extends MessageState {}

class MessageSending extends MessageState {}

class MessageSent extends MessageState {
  final Message message;

  const MessageSent({@required this.message}) : assert(message != null);

  @override
  List<Object> get props => [message];
}

class MessageSendError extends MessageState {}