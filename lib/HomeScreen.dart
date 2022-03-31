import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:my_trial_app/MovieData.dart';
import 'UserData.dart';
import 'MovieData.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final UserData userData = UserData();
  final MovieData movieData = MovieData();

  void setFavorite(int id) async {
    String result = await movieData.setFavoriteMovie(id);
    if (result.compareTo("OK") == 0) {

    } else {
      MotionToast.error(
        title: const Text('Error'),
        description: const Text(
          'Failed to add movie to favorites.',
        ),
      ).show(context);
    }
  }

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 550,
                        child: ListView.builder(
                            itemCount: movieData.movies.length,
                            itemBuilder: ((context, index) {
                              String title = movieData.movies.elementAt(index).name;
                              Image img = movieData.movies.elementAt(index).img;
                              int id = movieData.movies.elementAt(index).id;
                              return Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        img,
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            icon: const Icon(Icons.favorite, color: Colors.red, size: 30),
                                            onPressed: () {
                                              setState(() {
                                                setFavorite(id);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }))),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: userData.userMovies
                            .map((e) => Card(
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
                                    Text(e.name),
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
                        onPressed: () => {},
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> getMovies() async {
    String result = await movieData.getTopRatedMovies();
    if (!result.contains("OK")) {
      MotionToast.error(
        title: const Text('Error'),
        description: const Text(
          'Could not get top rated movies!',
        ),
      ).show(context);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMovies();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
