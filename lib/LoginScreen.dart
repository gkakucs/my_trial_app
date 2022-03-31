import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:my_trial_app/UserData.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _controllerUsername;
  late TextEditingController _controllerPassword;
  final UserData userData = UserData();

  @override
  void initState() {
    super.initState();
    _controllerUsername = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  @override
  void dispose() {
    _controllerUsername.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    if (_controllerUsername.text.isNotEmpty && _controllerPassword.text.isNotEmpty) {
      userData.userName = _controllerUsername.text;
      userData.password = _controllerPassword.text;
      String token = await userData.requestToken();
      print(token);
      if (!token.contains("Error")) {
        String result = await userData.validateWithLogin(token);
        if (result.compareTo("OK") == 0) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          MotionToast.error(
            title: const Text('Failed to log in!'),
            description: const Text(
              'Incorrect username or password!',
            ),
          ).show(context);
        }
      } else {
        MotionToast.error(
          title: const Text('Failed to log in!'),
          description: const Text(
            'Could not get Token!',
          ),
        ).show(context);
      }
    } else {
      MotionToast.error(
        title: const Text('Wrong input!'),
        description: const Text(
          'No username or password!',
        ),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoginScreen',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("My Trial App"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.fromLTRB(10, 50, 10, 100), child: Image.asset('assets/logo.png')),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Username:"),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: 150,
                          height: 35,
                          child: TextField(
                            obscureText: false,
                            controller: _controllerUsername,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Password:"),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          width: 150,
                          height: 35,
                          child: TextField(
                            obscureText: true,
                            controller: _controllerPassword,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
                    child: SizedBox(
                        width: 100,
                        height: 50,
                        child: ElevatedButton(onPressed: () => {loginUser()}, child: const Text("Login"))),
                  ),
                  Padding(
                    padding:const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () =>{Navigator.pushReplacementNamed(context, '/home')},
                      child: const Text("Home"),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
