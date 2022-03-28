import 'dart:convert';
import 'package:my_trial_app/UserData.dart';
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
  final UserData userData = UserData();

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
          'username': userData.getUserName(),
          'password': userData.getPassword(),
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

  Future<void> checkUserLoggedIn() async {
    String token = await requestToken();
    if (token.isNotEmpty && !token.contains("Error")) {
      String result = await validateWithLogin(token);
      if (result.compareTo("OK") == 0) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      MotionToast.error(title: const Text('Error'), description: const Text("Something went wrong")).show(context);
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
      Future.delayed(const Duration(seconds: 3), () => {checkUserLoggedIn()});
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
            body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(padding: const EdgeInsets.all(50.0), child: Image.asset('assets/logo.png')),
          const SpinKitRing(
            color: Colors.blue,
            size: 50.0,
          ),
        ])));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 5), () => {checkInternet()});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
