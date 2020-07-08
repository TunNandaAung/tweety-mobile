import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:tweety_mobile/constants/api_constants.dart';
import 'package:tweety_mobile/models/auth.dart';
import 'package:tweety_mobile/models/user.dart';
import 'package:tweety_mobile/preferences/preferences.dart';
import 'package:http_parser/http_parser.dart';

class UserApiClient {
  static const baseUrl =
      ApiConstants.BASE_URL; //url generated with `valet share command`
  static final userName = Prefer.prefs.getString('userName');
  final http.Client httpClient;

  UserApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<Auth> login({String email, String password}) async {
    final loginUrl = '$baseUrl/login';
    final loginResponse = await this.httpClient.post(
          loginUrl,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
          body: jsonEncode(
            <String, String>{
              'email': email,
              'password': password,
            },
          ),
        );
    print(loginResponse.statusCode);
    if (loginResponse.statusCode != 200) {
      throw Exception('Invalid Credentials');
    }

    final loginJson = jsonDecode(loginResponse.body);
    print(loginJson);
    return Auth.fromJson(loginJson);
  }

  Future<void> logout(String token) async {
    final logoutUrl = '$baseUrl/logout';

    final logoutResponse = await this.httpClient.post(
      logoutUrl,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    print(logoutResponse.statusCode);
    if (logoutResponse.statusCode != 200) {
      throw Exception('Invalid Credentials');
    }
  }

  Future<Auth> register({
    String name,
    String email,
    String password,
    String passwordConfirmation,
    String phone,
    String shopName,
    String address,
    File image,
    String fcmToken,
  }) async {
    final url = '$baseUrl/register';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = passwordConfirmation;
    request.fields['phone'] = phone;
    request.fields['shop_name'] = shopName;
    request.fields['address'] = address;
    request.fields['fcm_token'] = fcmToken;

    if (image != null) {
      var stream = new http.ByteStream(Stream.castFrom(image.openRead()));
      var length = await image.length();
      var multipartFile = new MultipartFile("image", stream, length,
          filename: basename(image.path),
          contentType: MediaType('multipart', 'form-data'));
      request.files.add(multipartFile);
    }

    Map<String, String> _headers = {
      'Accept': 'application/json',
    };

    request.headers.addAll(_headers);
    final response = await request.send();

    var _response = await http.Response.fromStream(response);

    if (response.statusCode == 422) {
      var errorJson = jsonDecode(_response.body)['errors'];

      if (errorJson['email'] != null) {
        throw Exception(errorJson['email'][0]);
      } else if (errorJson['password_confirmation'] != null) {
        throw Exception(errorJson['password_confirmation'][0]);
      } else
        throw Exception('Error registering account');
    } else if (response.statusCode != 201) {
      var _response = await http.Response.fromStream(response);
      print(_response.body);
      throw Exception('Error registering account');
    }

    final authJson = jsonDecode(_response.body);

    return Auth.fromJson(authJson);
  }

  Future<User> fetchAuthInfo() async {
    final url = '$baseUrl/profile';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          url,
          headers: requestHeaders(token),
        );
    if (response.statusCode != 200) {
      throw Exception('Error fetching profile.');
    }

    final userJson = jsonDecode(response.body)['data'];

    return User.fromJson(userJson);
  }

  Future<User> fetchUserInfo(String username) async {
    final url = '$baseUrl/profiles/$username';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
          url,
          headers: requestHeaders(token),
        );
    if (response.statusCode != 200) {
      throw Exception('Error fetching profile.');
    }
    print(response.body);
    final userJson = jsonDecode(response.body)['data'];

    return User.fromJson(userJson);
  }

  Future<void> editInfo(
      {String name, String shopAddress, String phone, String shopName}) async {
    final url = '$baseUrl/$userName/update-info';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.patch(
          url,
          headers: requestHeaders(token),
          body: jsonEncode(
            <String, String>{
              'name': name,
              'address': shopAddress,
              'shop_name': shopName,
              'phone': phone,
            },
          ),
        );
    if (response.statusCode != 201) {
      var responseJson = jsonDecode(response.body);
      print(responseJson);

      throw Exception('Error updating info!');
    }
    return;
  }

  Future<String> editPassword(
      {String oldPassword,
      String newPassword,
      String newPasswordConfirmation}) async {
    final url = '$baseUrl/$userName/update-password';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.patch(
          url,
          headers: requestHeaders(token),
          body: jsonEncode(
            <String, String>{
              'old_password': oldPassword,
              'new_password': newPassword,
              'new_password_confirmation': newPasswordConfirmation,
            },
          ),
        );
    if (response.statusCode == 422) {
      var errorJson = jsonDecode(response.body)['errors'];

      if (errorJson['old_password'] != null) {
        throw Exception('Provided password was incorrect.');
      } else if (errorJson['new_password'] != null) {
        throw Exception(errorJson['new_password'][0]);
      } else if (errorJson['new_password_confirmation'] != null) {
        throw Exception(errorJson['new_password_confirmation'][0]);
      }
    } else if (response.statusCode != 201) {
      throw Exception('Error updating password!');
    }
    return jsonDecode(response.body)['data'];
  }

  Future<void> editEmail({String password, String email}) async {
    final url = '$baseUrl/$userName/update-email';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.patch(
          url,
          headers: requestHeaders(token),
          body: jsonEncode(
            <String, String>{
              'password': password,
              'email': email,
            },
          ),
        );
    if (response.statusCode == 422) {
      var errorJson = jsonDecode(response.body)['errors'];

      if (errorJson['password'] != null) {
        throw Exception('Provided password was incorrect.');
      } else if (errorJson['password'] != null) {
        throw Exception(errorJson['password'][0]);
      }
    } else if (response.statusCode != 201) {
      var responseJson = jsonDecode(response.body);
      print(responseJson);

      throw Exception('Error updating email!');
    }
    return;
  }

  Future<void> editImage(File image) async {
    final url = '$baseUrl/profile/avatar';
    final token = Prefer.prefs.getString('token');

    final request = http.MultipartRequest('POST', Uri.parse(url));
    var stream = new http.ByteStream(Stream.castFrom(image.openRead()));
    var length = await image.length();
    var multipartFile = new MultipartFile("avatar", stream, length,
        filename: basename(image.path),
        contentType: MediaType('multipart', 'form-data'));
    request.files.add(multipartFile);

    Map<String, String> _headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    request.headers.addAll(_headers);
    final response = await request.send();

    if (response.statusCode != 204) {
      var _response = await http.Response.fromStream(response);
      print(_response.body);
      throw Exception('Error updating image.');
    }

    return;
  }

  Future<void> requestPasswordResetInfo(String email) async {
    final url = '$baseUrl/password/forgot';

    final response = await this.httpClient.post(
          url,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
          },
          body: jsonEncode(
            <String, String>{
              'email': email,
            },
          ),
        );

    if (response.statusCode == 422) {
      var errorMessage = jsonDecode(response.body)['message'];
      throw Exception(errorMessage);
    } else if (response.statusCode != 200) {
      throw Exception('Unable to send password reset info!');
    }
    return;
  }

  Future<String> getAvatar() async {
    final url = '$baseUrl/profile/avatar';

    final token = Prefer.prefs.getString('token');

    final response = await this.httpClient.get(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );
    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Invalid Credentials');
    }

    final avatar = jsonDecode(response.body)['data']['avatar'] as String;
    print(avatar);
    return avatar;
  }
}
