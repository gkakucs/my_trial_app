import 'package:flutter/material.dart';
import 'UserData.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserData userData = UserData();

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
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Movies"),
                  ),

                  SizedBox(
                    height: 100,
                    child: Text("Fuck you zsolti"),
                  ),
                ],
              ),
              ListView(
                children: [Text("Favorit Movies")],
              ),
              ListView(
                children: [Text("User Data")],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }
}
