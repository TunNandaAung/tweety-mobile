import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/chat.dart';
import 'package:tweety_mobile/repositories/chat_repository.dart';

part 'chat_room_event.dart';
part 'chat_room_state.dart';

class ChatRoomBloc extends Bloc<ChatRoomEvent, ChatRoomState> {
  final ChatRepository chatRepository;

  ChatRoomBloc({@required this.chatRepository})
      : assert(chatRepository != null),
        super(const ChatRoomState.initial());

  @override
  Stream<ChatRoomState> mapEventToState(
    ChatRoomEvent event,
  ) async* {
    if (event is FetchChatRoom) {
      yield* _mapFetchChatRoomToState(event);
    }
  }

  Stream<ChatRoomState> _mapFetchChatRoomToState(FetchChatRoom event) async* {
    yield const ChatRoomState.loading();

    try {
      final chat = await chatRepository.getChatRoom(username: event.username);
      yield ChatRoomState.success(chat);
    } on Exception {
      yield const ChatRoomState.failure();
    }
  }
}
