import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/message.dart';
import 'package:tweety_mobile/repositories/chat_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository chatRepository;

  MessageBloc({@required this.chatRepository})
      : assert(chatRepository != null),
        super(MessageInitial());

  // @override
  // Stream<Transition<MessageEvent, MessageState>> transformEvents(
  //   Stream<MessageEvent> events,
  //   TransitionFunction<MessageEvent, MessageState> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(const Duration(milliseconds: 500)),
  //     transitionFn,
  //   );
  // }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is FetchMessages) {
      yield* _mapFetchMessagesToState(event);
    } else if (event is SendMessage) {
      yield* _mapSendMessageToState(event);
    } else if (event is ReceiveMessage) {
      yield* _mapReceiveMessageToState(event);
    } else if (event is MarkAsRead) {
      yield* _mapMarkAsReadToState(event);
    } else if (event is UpdateReadAt) {
      yield* _mapUpdateReadAtToState(event);
    }
  }

  Stream<MessageState> _mapFetchMessagesToState(FetchMessages event) async* {
    final currentState = state;
    if (!_hasReachedMax(currentState, event)) {
      try {
        if (currentState is MessageInitial) {
          final messagePaginator = await chatRepository.getMessages(
              chatId: event.chatId, pageNumber: 1);
          yield MessageLoaded(
              messages: messagePaginator.messages,
              hasReachedMax: messagePaginator.lastPage == 1 ? true : false);
          return;
        }

        if (currentState is MessageLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final messagePaginator = await chatRepository.getMessages(
              chatId: event.chatId, pageNumber: pageNumber);

          yield messagePaginator.messages.isEmpty
              ? currentState.copyWith(hasReachedMax: true)
              : MessageLoaded(
                  messages: currentState.messages + messagePaginator.messages,
                  hasReachedMax: false,
                  pageNumber: pageNumber,
                );
        }
      } catch (_) {
        yield MessageError();
      }
    } else
      yield currentState;
  }

  bool _hasReachedMax(MessageState state, FetchMessages event) {
    return state is MessageLoaded && state.hasReachedMax;
  }

  // bool _sameChat(MessageState state, chatId) =>
  //     state is MessageLoaded && state.messages.first.chatId == chatId;

  Stream<MessageState> _mapSendMessageToState(SendMessage event) async* {
    final currentState = state;

    try {
      final message = await chatRepository.sendMessage(
          chatId: event.chatId, message: event.message);

      if (currentState is MessageLoaded) {
        final List<Message> updatedMessages = List.from(currentState.messages)
          ..insert(0, message);
        yield MessageSent(message: message);

        yield currentState.copyWith(messages: updatedMessages);
      }
    } catch (_) {
      if (currentState is MessageLoaded) {
        yield MessageSendError();
      }
    }
  }

  Stream<MessageState> _mapReceiveMessageToState(ReceiveMessage event) async* {
    final currentState = state;

    try {
      if (currentState is MessageLoaded) {
        final List<Message> updatedMessages = List.from(currentState.messages)
          ..insert(0, event.message);
        yield MessageSent(message: event.message);

        yield currentState.copyWith(messages: updatedMessages);
      }
    } catch (_) {
      if (currentState is MessageLoaded) {
        yield MessageSendError();
      }
    }
  }

  Stream<MessageState> _mapMarkAsReadToState(MarkAsRead event) async* {
    chatRepository.markAsRead(chatId: event.chatId, username: event.username);
    yield state;
  }

  Stream<MessageState> _mapUpdateReadAtToState(UpdateReadAt event) async* {
    final currentState = state;

    try {
      if (currentState is MessageLoaded) {
        final List<Message> updatedMessages =
            currentState.messages.map((message) {
          if (message.readAt == null) {
            message.readAt = DateTime.now();
          }
          return message;
        }).toList();

        yield currentState.copyWith(messages: updatedMessages);
      }
    } catch (_) {
      yield currentState;
    }
  }
}
