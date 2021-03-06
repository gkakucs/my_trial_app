import 'package:my_trial_app/MovieData.dart';
import 'package:my_trial_app/UserData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final Connectivity _connectivity = Connectivity();
  final UserData userData = UserData();
  final MovieData movieData = MovieData();

  Future<void> checkUserLoggedIn() async{

    if (userData.sessionId.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
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
      Future.delayed(const Duration(seconds: 5), () => {checkUserLoggedIn()});
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
    super.initState();
    movieData.getConfiguration();
    userData.readSessionID().then((value) => checkInternet());
   // Future.delayed(const Duration(seconds: 5), () => {checkInternet()});
  }

  @override
  void dispose() {
    super.dispose();
  }
}
