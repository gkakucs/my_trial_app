import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_trial_app/Movies.dart';
import 'package:my_trial_app/MyConstants.dart';

class UserData {
  static final UserData _userData = UserData._internal();
  String userName = '';
  String password = '';
  List<Movies> userMovies = List<Movies>.empty();

  UserData._internal();

  factory UserData() {
    return _userData;
  }

  String getUserName() {
    return userName;
  }

  String getPassword() {
    return password;
  }

  Future<String> requestToken() async {
    final response = await http
        .get(Uri.parse('https://api.themoviedb.org/3/authentication/token/new?api_key=' + MyConstants.API_Key));
    if (response.statusCode == 200) {
      //Status OK
      try {
        Map<String, dynamic> queryData = jsonDecode(response.body);
        if (queryData["success"] == true) {
          return queryData["request_token"];
        } else {
          return "ErrorFailed";
        }
      } on Exception {
        return "ErrorException";
      }
    } else {
      //Status Not OK
      if (response.statusCode == 400) {
        return "Error400";
      } else {
        if (response.statusCode == 404) {
          return "Error404";
        } else {
          return "ErrorX";
        }
      }
    }
  }

  Future<String> validateWithLogin(String token) async {
    final response = await http.post(
        Uri.parse(
            "https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=" + MyConstants.API_Key),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': userName,
          'password': password,
          'request_token': token
        }));
    if (response.statusCode == 200) {
      //Status OK
      try {
        Map<String, dynamic> queryData = jsonDecode(response.body);
        if (queryData["expires_at"] == true) {
          return "OK";
        } else {
          //Status Not OK
          return "ErrorFailed";
        }
      } on Exception {
        return "ErrorException";
      }
    } else {
      //Status Not OK
      if (response.statusCode == 400) {
        return "Error400";
      } else {
        if (response.statusCode == 404) {
          return "Error404";
        } else {
          return "ErrorX";
        }
      }
    }
  }

}
