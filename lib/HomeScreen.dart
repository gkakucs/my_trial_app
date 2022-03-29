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
                    child: ListView(
                      children: userData.userMovies.map((e) => Text(e.Name)).toList(growable: false),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: userData.userMovies
                          .map((e) =>
                          Card(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        'assets/logo.png',
                                        scale: 1,
                                      )),
                                  Text(e.Name),
                                  const Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 10,
                                    ),
                                  )
                                ],
                              )))
                          .toList(growable: false),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: Text("Username:"),
                        ),
                        SizedBox(
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: Text("Password:"),
                        ),
                        SizedBox(
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
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(1, 10, 1, 10),
                    child: ElevatedButton(
                      child: const Text("Change Password"),
                      onPressed: ()=>{},
                    ),
                  )
                ],
              ),
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
