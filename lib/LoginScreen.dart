import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LoginScreen',
      home: Scaffold(
        appBar: AppBar(
          title: const Text("My Trial App"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 50, 10, 100),
                child: Image.asset('assets/logo.png')
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("Username:"),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: 150,
                        height: 35,
                        child: TextField(
                          obscureText: false,
                          decoration: InputDecoration(
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
                  children: const [
                    Text("Password:"),
                    Padding(
                      padding: EdgeInsets.all(4.0),
                      child: SizedBox(
                        width: 150,
                        height: 35,
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
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
                      child: ElevatedButton(
                          onPressed: ()=>{
                            Navigator.pushReplacementNamed(context, '/home')
                          },
                          child: const Text("Login"))
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
