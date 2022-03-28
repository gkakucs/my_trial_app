import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:my_trial_app/MyConstants.dart';
import 'package:dart_json_mapper/dart_json_mapper.dart' show JsonMapper, jsonSerializable, JsonProperty;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Connectivity _connectivity = Connectivity();

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
          return "";
        }
      } on Exception {
        return "";
      }
    } else {
      //Status Not OK
      return "";
    }
  }

  Future<bool> validateWithLogin(String token) async {
    final response = await http
        .post(Uri.parse("https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=" + token));
    if (response.statusCode == 200) {
      //Status OK
      try {
        Map<String, dynamic> queryData = jsonDecode(response.body);
        if (queryData["success"] == true) {
          return true;
        } else {
          //Status Not OK
          return false;
        }
      } on Exception {
        return false;
      }
    } else {
      //Status Not OK
      return false;
    }
  }

  Future<void> checkUserLoggedIn() async {
    bool result = false;
    String token = await requestToken();
    if (token.isNotEmpty) {
      result = await validateWithLogin(token);
    }

    if (result) {
      //User Logged in
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      //User not logged in
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> checkInternet() async {
    ConnectivityResult connectivityResult = await _connectivity.checkConnectivity();

    if ((connectivityResult == ConnectivityResult.mobile) || (connectivityResult == ConnectivityResult.wifi)) {
      MotionToast.success(
        title: const Text('Connected to network'),
        description: const Text(
          'Network connection OK',
        ),
      ).show(context);
      checkUserLoggedIn();
    } else {
      MotionToast.error(
        title: const Text('Error'),
        description: const Text(
          'No Network connection',
        ),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SplashScreen',
      home: Scaffold(
          body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: const EdgeInsets.all(50.0), child: Image.asset('assets/logo.png')),
          const SpinKitRing(
            color: Colors.blue,
            size: 50.0,
          ),
          ElevatedButton(
              onPressed: () => {
                    MotionToast.success(
                      title: const Text('Test'),
                      description: const Text(
                        'Desc',
                      ),
                    ).show(context)
                  },
              child: Text("Toast")),
        ],
      )),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}

class NewTokenResponse {
  final bool isSuccess;
  final String expirationDate;
  final String requestToken;

  const NewTokenResponse({required this.isSuccess, required this.expirationDate, required this.requestToken});

  factory NewTokenResponse.fromJson(Map<String, dynamic> json) {
    return NewTokenResponse(
        isSuccess: json["success"], expirationDate: json["expires_at"], requestToken: json["request_token"]);
  }
}

class AuthenticationResponse {}
