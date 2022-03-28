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
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("My Trial App"),
            bottom: const TabBar(
              tabs: [
                Tab(child: Text("Movie List")),
                Tab(child: Text("Favorites")),
                Tab(child: Text("User data")),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Text("A"),
              Text("B"),
              Text("C")
            ],
          ),
        ),
      ),
    );
  }
}
