import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/models/chat.dart';
import 'package:tweety_mobile/repositories/chat_repository.dart';
import 'package:tweety_mobile/utils/helpers.dart';

part 'chat_event.dart';
part 'chat_state.dart';

const throttleDuration = Duration(milliseconds: 500);

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({this.chatRepository}) : super(const ChatState()) {
    on<FetchChatList>(
      _onFetchChatList,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onFetchChatList(
      FetchChatList event, Emitter<ChatState> emit) async {
    if (state.hasReachedMax) return emit(state);
    try {
      if (state.status == ChatStatus.initial) {
        final chatPaginator = await chatRepository.getChatList(pageNumber: 1);
        emit(state.copyWith(
          status: ChatStatus.success,
          chatList: chatPaginator.chats,
          hasReachedMax: chatPaginator.lastPage == 1 ? true : false,
        ));
      }
      final chatPaginator =
          await chatRepository.getChatList(pageNumber: state.pageNumber + 1);

      emit(chatPaginator.chats.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: ChatStatus.success,
              chatList: List.of(state.chatList)..addAll(chatPaginator.chats),
              hasReachedMax: false,
            ));
    } on Exception {
      emit(state.copyWith(status: ChatStatus.failure));
    }
  }
}
