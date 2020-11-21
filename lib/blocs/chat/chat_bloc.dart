import 'dart:async';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/models/chat.dart';
import 'package:tweety_mobile/repositories/chat_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({@required this.chatRepository})
      : assert(chatRepository != null),
        super(const ChatState());

  @override
  Stream<Transition<ChatEvent, ChatState>> transformEvents(
    Stream<ChatEvent> events,
    TransitionFunction<ChatEvent, ChatState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is FetchChatList) {
      yield await _mapFetchChatListToState(state);
    }
  }

  Future<ChatState> _mapFetchChatListToState(ChatState state) async {
    if (state.hasReachedMax) return state;
    try {
      if (state.status == ChatStatus.initial) {
        final chatPaginator = await chatRepository.getChatList(pageNumber: 1);
        return state.copyWith(
          status: ChatStatus.success,
          chatList: chatPaginator.chats,
          hasReachedMax: chatPaginator.lastPage == 1 ? true : false,
        );
      }
      final chatPaginator =
          await chatRepository.getChatList(pageNumber: state.pageNumber + 1);

      return chatPaginator.chats.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: ChatStatus.success,
              chatList: List.of(state.chatList)..addAll(chatPaginator.chats),
              hasReachedMax: false,
            );
    } on Exception {
      return state.copyWith(status: ChatStatus.failure);
    }
  }
}
