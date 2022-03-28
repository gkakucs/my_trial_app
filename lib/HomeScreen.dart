import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HomeScreen',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Home Screen"
          ),
        ),
        body: Column(
          children: const [
            Text("Home"),
          ],
        ),
      ),
    );
  }
}
