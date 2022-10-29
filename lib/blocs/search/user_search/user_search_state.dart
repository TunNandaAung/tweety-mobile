part of 'user_search_bloc.dart';

class UserSearchState {
  final bool isLoading;
  final List<User> users;
  final bool hasError;

  const UserSearchState({
    required this.isLoading,
    required this.users,
    required this.hasError,
  });

  factory UserSearchState.initial() {
    return const UserSearchState(
      users: [],
      isLoading: false,
      hasError: false,
    );
  }

  factory UserSearchState.loading() {
    return const UserSearchState(
      users: [],
      isLoading: true,
      hasError: false,
    );
  }

  factory UserSearchState.success(List<User> users) {
    return UserSearchState(
      users: users,
      isLoading: false,
      hasError: false,
    );
  }

  factory UserSearchState.error() {
    return const UserSearchState(
      users: [],
      isLoading: false,
      hasError: true,
    );
  }

  @override
  String toString() =>
      'UserSearchState {users: ${users.toString()}, isLoading: $isLoading, hasError: $hasError }';
}
