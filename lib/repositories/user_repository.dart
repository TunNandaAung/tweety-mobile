import 'dart:io';

import 'package:meta/meta.dart';
import 'package:tweety_mobile/models/auth.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:tweety_mobile/services/user_api_client.dart';

class UserRepository {
  final UserApiClient userApiClient;

  UserRepository({@required this.userApiClient})
      : assert(userApiClient != null);

  Future<Auth> loginWithCredentials(String email, String password) async {
    return userApiClient.login(email: email, password: password);
  }

  Future<bool> isSignedIn() async {
    final token = Prefer.prefs.getString('token');
    return token != null;
  }

  Future<void> logOut() async {
    final token = Prefer.prefs.getString('token');
    userApiClient.logout(token);
    Prefer.prefs.clear();
  }

  Future<Auth> register(
      String name,
      String email,
      String password,
      String passwordConfirmation,
      String phone,
      String shopName,
      String address,
      File image) async {
    // String fcmToken = await getFcmtoken();

    return userApiClient.register(
      name: name,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      phone: phone,
      shopName: shopName,
      address: address,
      image: image,
    );
  }

  Future<User> getAuthUserInfo() async {
    return userApiClient.fetchAuthInfo();
  }

  Future<User> getUserInfo(String userName) async {
    return userApiClient.fetchUserInfo(userName);
  }

  Future<void> updateInfo(
      String name, String shopAddress, String phone, String shopName) async {
    return userApiClient.editInfo(
        name: name, shopAddress: shopAddress, phone: phone, shopName: shopName);
  }

  Future<String> updatePassword(String oldPassword, String newPassword,
      String newPasswordConfirmation) async {
    return userApiClient.editPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation);
  }

  Future<void> updateEmail(String password, String email) async {
    return userApiClient.editEmail(
      password: password,
      email: email,
    );
  }

  Future<void> updateImage(File image) async {
    return userApiClient.editImage(image);
  }

  // Future<String> getFcmtoken() async {
  //   final FirebaseMessaging fcm = FirebaseMessaging();
  //   String fcmToken = await fcm.getToken();

  //   Prefer.prefs.setString('fcmToken', fcmToken);
  //   print("FCM_TOKEN: " + fcmToken);

  //   return fcmToken;
  // }

  Future<void> requestPasswordResetInfo(String email) async {
    return userApiClient.requestPasswordResetInfo(email);
  }

  Future<String> getAvatar() async {
    return userApiClient.getAvatar();
  }
}
