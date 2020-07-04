import 'package:equatable/equatable.dart';

class Auth extends Equatable {
  final String token;
  final int userID;
  final String username;

  const Auth({this.userID, this.username, this.token});

  @override
  List<Object> get props => [
        token,
        userID,
        username,
      ];

  static Auth fromJson(dynamic json) {
    final authData = json['data'];
    return Auth(
      token: authData['token'] as String,
      userID: authData['user_id'] as int,
      username: authData['username'] as String,
    );
  }
}
