import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tweety_mobile/models/message.dart';
import 'package:tweety_mobile/repositories/chat_repository.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final ChatRepository chatRepository;

  MessageBloc({@required this.chatRepository})
      : assert(chatRepository != null),
        super(MessageInitial());

  @override
  Stream<Transition<MessageEvent, MessageState>> transformEvents(
    Stream<MessageEvent> events,
    TransitionFunction<MessageEvent, MessageState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is FetchMessages) {
      yield* _mapFetchMessagesToState(event);
    }
  }

  Stream<MessageState> _mapFetchMessagesToState(FetchMessages event) async* {
    final currentState = state;
    if (!_hasReachedMax(currentState, event)) {
      try {
        if (currentState is MessageInitial) {
          final messagePaginator = await chatRepository.getMessages(
              chatID: event.chatID, pageNumber: 1);
          yield MessageLoaded(
              messages: messagePaginator.messages,
              hasReachedMax: messagePaginator.lastPage == 1 ? true : false);
          return;
        }

        if (currentState is MessageLoaded) {
          var pageNumber = currentState.pageNumber + 1;
          final messagePaginator = await chatRepository.getMessages(
              chatID: event.chatID, pageNumber: pageNumber);

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
    }
  }

  bool _hasReachedMax(MessageState state, FetchMessages event) {
    return state is MessageLoaded && state.hasReachedMax;
  }
}
