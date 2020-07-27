part of 'user_search_bloc.dart';

class UserSearchEvent {
  final String query;

  const UserSearchEvent(this.query);

  @override
  String toString() => 'UserSearchEvent { query: $query }';
}
