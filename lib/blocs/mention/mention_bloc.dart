import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/repositories/user_repository.dart';
import 'package:tweety_mobile/utils/helpers.dart';

part 'mention_event.dart';
part 'mention_state.dart';

const throttleDuration = Duration(milliseconds: 300);

class MentionBloc extends Bloc<MentionEvent, MentionState> {
  final UserRepository userRepository;
  MentionBloc({required this.userRepository}) : super(MentionInitial()) {
    on<FindMentionedUser>(
      _onFindMentionedUser,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onFindMentionedUser(
      FindMentionedUser event, Emitter<MentionState> emit) async {
    emit(MentionUserLoading());
    try {
      final users = await userRepository.findMentionedUsers(event.query!);
      emit(MentionUserLoaded(query: event.query!, users: users));
    } catch (e) {
      emit(MentionUserError());
    }
  }
}
