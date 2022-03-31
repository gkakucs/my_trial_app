import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_trial_app/Movies.dart';
import 'package:my_trial_app/MyConstants.dart';
/*
* TMDB:
* Username: Pantokrator.dev
* Password: (szokasos)
* */

class UserData {
  static final UserData _userData = UserData._internal();
  String userName = '';
  String password = '';
  List<Movies> userMovies = List<Movies>.empty();

  UserData._internal();

  factory UserData() {
    return _userData;
  }

  Future<String> requestToken() async {
    final response = await http
        .get(Uri.parse('https://api.themoviedb.org/3/authentication/token/new?api_key=' + MyConstants.API_Key));

    switch (response.statusCode) {
      case 200: //Status OK
        {
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
        }
      case 400: //Error 400
        {
          return "Error400";
        }
      case 404: //Error 404
        {
          return "Error404";
        }
      default:
        {
          return "ErrorX";
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
        body: jsonEncode(<String, String>{'username': userName, 'password': password, 'request_token': token}));

    switch (response.statusCode) {
      case 200:
        {
          //Status OK
          try {
            Map<String, dynamic> queryData = jsonDecode(response.body);
            if (queryData["success"] == true) {
              return "OK";
            } else {
              //Status Not OK
              return "ErrorFailed";
            }
          } on Exception {
            return "ErrorException";
          }
        }
      case 401:
        {
          return "Error401";
        }
      case 404:
        {
          return "Error404";
        }
      default:
        {
          return "ErrorX";
        }
    }
  }
}
