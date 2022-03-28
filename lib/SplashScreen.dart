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

  Future<void> CheckInternet() async {
    ConnectivityResult connectivityResult = await _connectivity.checkConnectivity();

    if ((connectivityResult == ConnectivityResult.mobile) || (connectivityResult == ConnectivityResult.wifi)) {
      MotionToast.success(
        title: const Text('Connected to network'),
        description: const Text(
          'Network connection OK',
        ),
      ).show(context);
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
    CheckInternet();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
