part of 'chat_room_bloc.dart';

enum ChatRoomStatus { initial, loading, success, failure }

class ChatRoomState extends Equatable {
  const ChatRoomState._({
    this.status = ChatRoomStatus.initial,
    this.chat,
  });

  const ChatRoomState.initial() : this._();

  const ChatRoomState.loading() : this._(status: ChatRoomStatus.loading);

  const ChatRoomState.success(Chat chat)
      : this._(status: ChatRoomStatus.success, chat: chat);

  const ChatRoomState.failure() : this._(status: ChatRoomStatus.failure);

  final ChatRoomStatus status;
  final Chat chat;

  @override
  List<Object> get props => [status, chat];
}
