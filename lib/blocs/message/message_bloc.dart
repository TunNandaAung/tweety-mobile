import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/models/message.dart';
import 'package:tweety_mobile/repositories/chat_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository chatRepository;

  MessageBloc({required this.chatRepository}) : super(MessageInitial()) {
    on<FetchMessages>(_onFetchMessages);
    on<SendMessage>(_onSendMessage);
    on<ReceiveMessage>(_onReceiveMessage);
    on<MarkAsRead>(_onMarkAsRead);
    on<UpdateReadAt>(_onUpdateReadAt);
  }

  Future<void> _onFetchMessages(
      FetchMessages event, Emitter<MessageState> emit) async {
    final currentState = state;
    if (!_hasReachedMax(currentState, event)) {
      try {
        if (currentState is MessageInitial) {
          final messagePaginator = await chatRepository.getMessages(
              chatId: event.chatId, pageNumber: 1);
          return emit(MessageLoaded(
            messages: messagePaginator.messages,
            hasReachedMax: messagePaginator.lastPage == 1 ? true : false,
          ));
        }

        if (currentState is MessageLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final messagePaginator = await chatRepository.getMessages(
              chatId: event.chatId, pageNumber: pageNumber);

          emit(messagePaginator.messages.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : MessageLoaded(
                  messages: currentState.messages + messagePaginator.messages,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                ));
        }
      } catch (_) {
        emit(MessageError());
      }
    } else {
      emit(currentState);
    }
  }

  bool _hasReachedMax(MessageState state, FetchMessages event) {
    return state is MessageLoaded && state.hasReachedMax;
  }

  // bool _sameChat(MessageState state, chatId) =>
  //     state is MessageLoaded && state.toString().first.chatId == chatId;

  Future<void> _onSendMessage(
      SendMessage event, Emitter<MessageState> emit) async {
    final currentState = state;

    try {
      final message = await chatRepository.sendMessage(
          chatId: event.chatId, message: event.message);

      if (currentState is MessageLoaded) {
        final List<Message> updatedMessages = List.from(currentState.messages)
          ..insert(0, message);
        emit(MessageSent(message: message));

        emit(currentState.copyWith(messages: updatedMessages));
      }
    } catch (_) {
      if (currentState is MessageLoaded) {
        emit(MessageSendError());
      }
    }
  }

  Future<void> _onReceiveMessage(
      ReceiveMessage event, Emitter<MessageState> emit) async {
    final currentState = state;

    try {
      if (currentState is MessageLoaded) {
        final List<Message> updatedMessages = List.from(currentState.messages)
          ..insert(0, event.message);
        emit(MessageSent(message: event.message));

        emit(currentState.copyWith(messages: updatedMessages));
      }
    } catch (_) {
      if (currentState is MessageLoaded) {
        emit(MessageSendError());
      }
    }
  }

  Future<void> _onMarkAsRead(
      MarkAsRead event, Emitter<MessageState> emit) async {
    chatRepository.markAsRead(chatId: event.chatId, username: event.username);
    emit(state);
  }

  Future<void> _onUpdateReadAt(
      UpdateReadAt event, Emitter<MessageState> emit) async {
    final currentState = state;

    try {
      if (currentState is MessageLoaded) {
        final List<Message> updatedMessages =
            currentState.messages.map((message) {
          message.readAt ??= DateTime.now();
          return message;
        }).toList();

        emit(currentState.copyWith(messages: updatedMessages));
      }
    } catch (_) {
      emit(currentState);
    }
  }
}
