import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:my_trial_app/Movies.dart';
import 'package:my_trial_app/MovieData.dart';
import 'package:my_trial_app/MyConstants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  int id = 0;
  String name = '';
  String userName = '';
  String sessionId = '';
  String avatarPath = '';
  bool includeAdult = false;
  String requestTokenString = '';
  Image avatarImg = Image.asset('logo.png');

  List<Movies> userMovies = List<Movies>.empty();

  UserData._internal();

  static final UserData _userData = UserData._internal();

  factory UserData() {
    return _userData;
  }

  Future<bool> requestToken() async {
    final response = await http
        .get(Uri.parse('https://api.themoviedb.org/3/authentication/token/new?api_key=' + MyConstants.API_Key));

    switch (response.statusCode) {
      case 200: //Status OK
        {
          Map<String, dynamic> queryData = jsonDecode(response.body);
          if (queryData["success"] == true) {
            requestTokenString = queryData["request_token"];
            return true;
          } else {
            return false;
          }
        }
      case 400: //Error 400
        {
          return false;
        }
      case 404: //Error 404
        {
          return false;
        }
      default:
        {
          return false;
        }
    }
  }

  Future<bool> getSessionID() async {
    final response = await http.post(
        Uri.parse("https://api.themoviedb.org/3/authentication/session/new?api_key=" + MyConstants.API_Key),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'request_token': requestTokenString}));
    switch (response.statusCode) {
      case 200:
        {
          Map<String, dynamic> queryData = jsonDecode(response.body);
          sessionId = queryData["session_id"];
          return true;
        }
      case 401:
        {
          return false;
        }
      case 404:
        {
          return false;
        }
      default:
        {
          return false;
        }
    }
  }

  Future<void> validateWithLogin() async {
    await launch(
      "https://www.themoviedb.org/authenticate/" + requestTokenString,
      forceSafariVC: false,
      forceWebView: false,
    );
  }

  Future<Image> getImage(String path) async {
    MovieData movieData = MovieData();
    return Image.network(Uri.parse(movieData.baseUrl + movieData.sizes[3] + path).toString());
  }

  Future<bool> getUserDetails() async {
    //https://developers.themoviedb.org/3/account/get-account-details
    final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/account?api_key=' + MyConstants.API_Key + '&session_id=' + sessionId));

    switch (response.statusCode) {
      case 200: //Status OK
        {
          Map<String, dynamic> queryData = jsonDecode(response.body);

          id = queryData["id"];
          name = queryData["name"];
          userName = queryData["username"];
          includeAdult = queryData["include_adult"];
          Map<String, dynamic> avatar = queryData["avatar"];
          Map<String, dynamic> tmdb = avatar["tmdb"];
          avatarPath = tmdb["avatar_path"];
          avatarImg = await getImage(avatarPath);
          return true;
        }
      case 401: //Error 400
        {
          return false;
        }
      case 404: //Error 404
        {
          return false;
        }
      default:
        {
          return false;
        }
    }
  }

  Future<bool> logoutUser() async {
    //https://developers.themoviedb.org/3/authentication/delete-session
    final response = await http.delete(
        Uri.parse("https://api.themoviedb.org/3/authentication/session?api_key=" + MyConstants.API_Key),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{'session_id': sessionId}));
    switch (response.statusCode) {
      case 200:
        {
          sessionId = "";
          await writeSessionID();
          return true;
        }
      case 401:
        {
          return false;
        }
      case 404:
        {
          return false;
        }
      default:
        {
          return false;
        }
    }
  }

  Future<bool> checkForPreviousUserSession() async {
    final _prefs = await SharedPreferences.getInstance();
    final String? previousSessionId = _prefs.getString('session_id');
    //if(previousSessionId)
    return false;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeSessionID() async {
    final file = await _localFile;
    return file.writeAsString(sessionId);
  }

  Future<void> readSessionID() async {
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      sessionId = contents;
    } catch (e) {
      sessionId = "";
    }
  }
}
