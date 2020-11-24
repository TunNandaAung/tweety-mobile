part of 'chat_bloc.dart';

enum ChatStatus { initial, success, failure }

class ChatState extends Equatable {
  const ChatState({
    this.status = ChatStatus.initial,
    this.chatList = const <Chat>[],
    this.hasReachedMax = false,
    this.pageNumber = 1,
  });

  final ChatStatus status;
  final List<Chat> chatList;
  final bool hasReachedMax;
  final int pageNumber;

  ChatState copyWith(
      {ChatStatus status,
      List<Chat> chatList,
      bool hasReachedMax,
      int pageNumber}) {
    return ChatState(
      status: status ?? this.status,
      chatList: chatList ?? this.chatList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      pageNumber: pageNumber ?? this.pageNumber,
    );
  }

  @override
  List<Object> get props => [status, chatList, hasReachedMax];
}
