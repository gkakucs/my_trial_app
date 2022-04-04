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
    if (await movieData.setFavoriteMovie(id, userData.sessionId)) {
      MotionToast.success(
        title: const Text('Info'),
        description: const Text(
          'Added to favorites.',
        ),
      ).show(context);
      await movieData.getFavoriteMovies(userData.sessionId);
      setState(() {});
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
    movieData.getFavoriteMovies(userData.sessionId);
    return MaterialApp(
        title: 'HomeScreen',
        home: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("My IMDB App"),
              bottom: const TabBar(
                tabs: [
                  Tab(child: Text("Movie List"),),
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
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(1.0),
                                            child: SizedBox(
                                              child: img,
                                              width: 300,
                                              height: 400,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0,0,15,0),
                                            child: IconButton(
                                              icon: const Icon(Icons.favorite, color: Colors.red, size: 30),
                                              onPressed: () {
                                                setFavorite(id);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }))),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: movieData.favoriteMovies.length,
                        itemBuilder: (BuildContext context, int index) {
                          String title = movieData.favoriteMovies.elementAt(index).name;
                          Image img = movieData.favoriteMovies.elementAt(index).img;
                          int id = movieData.favoriteMovies.elementAt(index).id;
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    child: img,
                                    width: 300,
                                    height: 400,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(width: 200, height: 200, child: userData.avatarImg),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 120, height: 50, child: Text("ID: ")),
                        SizedBox(width: 120, height: 50, child: Text(userData.id.toString())),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 120, height: 50, child: Text("Name: ")),
                        SizedBox(width: 120, height: 50, child: Text(userData.name.toString())),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 120, height: 50, child: Text("Username: ")),
                        SizedBox(width: 120, height: 50, child: Text(userData.userName.toString())),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 120, height: 50, child: Text("Adult content: ")),
                        SizedBox(width: 120, height: 50, child: Text(userData.includeAdult.toString())),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () => {
                              setState(() {
                                getUserInformation();
                              })
                            },
                        child: const Text("Refresh"))
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> getUserInformation() async {
    if (!await userData.getUserDetails()) {
      MotionToast.error(
        title: const Text('Error'),
        description: const Text(
          'Could not get user data!',
        ),
      ).show(context);
    }
  }

  Future<void> getUiData() async {
    if (!await movieData.getTopRatedMovies()) {
      MotionToast.error(
        title: const Text('Error'),
        description: const Text(
          'Could not get top rated movies!',
        ),
      ).show(context);
    }
    if (!await movieData.getFavoriteMovies(userData.sessionId)) {
      MotionToast.error(
        title: const Text('Error'),
        description: const Text(
          'Could not get favorite movies!',
        ),
      ).show(context);
    }
    getUserInformation();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUiData();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
