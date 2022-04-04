import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:my_trial_app/UserData.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserData userData = UserData();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getSession() async {
    if (await userData.getSessionID()) {
      userData.writeSessionID();
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      MotionToast.error(
        title: const Text('Error'),
        description: const Text(
          'Invalid session ID',
        ),
      ).show(context);
    }
  }

  Future<void> loginUser() async {
    if (await userData.requestToken()) {
      await userData.validateWithLogin();
    } else {
      MotionToast.error(
        title: const Text('Error'),
        description: const Text(
          'Invalid request token',
        ),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //loginUser();
    return MaterialApp(
      title: 'LoginScreen',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("My TMDB App"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(padding: const EdgeInsets.fromLTRB(10, 50, 10, 100), child: Image.asset('assets/logo.png')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SizedBox(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(onPressed: () => {loginUser()}, child: const Text("Web login"))),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: SizedBox(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(onPressed: () => {getSession()}, child: const Text("Login"))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
