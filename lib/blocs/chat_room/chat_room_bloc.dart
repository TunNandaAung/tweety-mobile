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

  ChatRoomBloc({this.chatRepository}) : super(const ChatRoomState.initial()) {
    on<FetchChatRoom>(_onFetchChatRoom);
  }

  Future<void> _onFetchChatRoom(
      FetchChatRoom event, Emitter<ChatRoomState> emit) async {
    emit(ChatRoomState.loading());

    try {
      final chat = await chatRepository.getChatRoom(username: event.username);
      emit(ChatRoomState.success(chat));
    } on Exception {
      emit(ChatRoomState.failure());
    }
  }
}
