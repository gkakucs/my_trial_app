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
    movieData.getFavoriteMovies();
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
                        children: [],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("id"),
                    Text("name"),
                    Text("username"),
                    Text("Adult content"),
                    Text("Avatar"),
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
