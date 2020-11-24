part of 'chat_room_bloc.dart';

abstract class ChatRoomEvent extends Equatable {
  const ChatRoomEvent();

  @override
  List<Object> get props => [];
}

class FetchChatRoom extends ChatRoomEvent {
  final String username;

  const FetchChatRoom({@required this.username}) : assert(username != null);

  @override
  List<Object> get props => [username];
}
