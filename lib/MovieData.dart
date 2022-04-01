import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_trial_app/Movies.dart';
import 'package:my_trial_app/MyConstants.dart';

class MovieData {
  static final MovieData _movieData = MovieData._internal();
  String baseUrl = '';
  List<String> sizes = List.empty(growable: true);
  List<Movies> movies = List.empty(growable: true);
  List<Movies> favoriteMovies = List.empty(growable: true);

  MovieData._internal();

  factory MovieData() {
    return _movieData;
  }

  Future<bool> getConfiguration() async {
    final response =
        await http.get(Uri.parse('https://api.themoviedb.org/3/configuration?api_key=' + MyConstants.API_Key));
    switch (response.statusCode) {
      case 200: //Status OK
        {
          try {
            Map<String, dynamic> queryData = jsonDecode(response.body);
            //print(queryData);
            if (queryData.isNotEmpty) {
              try {
                Map<String, dynamic> config = queryData["images"];
                baseUrl = config["base_url"];
                sizes = List<String>.from(config["poster_sizes"]);
                return true;
              } on Exception catch (E) {
                print(E.toString());
                return false;
              }
            } else {
              return false;
            }
          } on Exception {
            return false;
          }
        }
      case 400: //Error 400
        {
          return false;
        }
      case 404: //Error 404
        {
          return false;
        }
      default:
        {
          return false;
        }
    }
  }

  Future<bool> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(
        "https://api.themoviedb.org/3/movie/top_rated?api_key=" + MyConstants.API_Key + "&language=en-US&page=1"));
    switch (response.statusCode) {
      case 200:
        {
          try {
            Map<String, dynamic> queryData = jsonDecode(response.body);
            List<dynamic> movieList = queryData["results"];
            movies.clear();
            for (var element in movieList) {
              Map<String, dynamic> movieData = Map<String, dynamic>.from(element);
              Movies movie = Movies.named(movieData["title"], false, movieData["id"], movieData["poster_path"]);
              movie.img = await getImage(movie);
              movies.add(movie);
            }

            if (movies.isNotEmpty) {
              return true;
            } else {
              return false;
            }
          } on Exception {
            return false;
          }
        }
      case 401:
        {
          return false;
        }
      case 404:
        {
          return false;
        }
      default:
        {
          return false;
        }
    }
  }

  Future<Image> getImage(Movies movie) async {
    return Image.network(Uri.parse(baseUrl + sizes[3] + movie.posterPath).toString());
  }

  Future<bool> getFavoriteMovies(String sessionID) async {
    //https://developers.themoviedb.org/3/account/get-favorite-movies
    final response = await http.get(Uri.parse("https://api.themoviedb.org/3/account/" +
        MyConstants.ACCOUNT_ID +
        "/favorite/movies?api_key=" +
        MyConstants.API_Key +
        "&session_id=" +
        sessionID +
        "&language=en-US&sort_by=created_at.asc&page=1"));
    switch (response.statusCode) {
      case 200:
        {
          try {
            Map<String, dynamic> queryData = jsonDecode(response.body);
            List<dynamic> movieList = queryData["results"];
            favoriteMovies.clear();
            for (var element in movieList) {
              Map<String, dynamic> movieData = Map<String, dynamic>.from(element);
              Movies movie = Movies.named(movieData["title"], false, movieData["id"], movieData["poster_path"]);
              movie.img = await getImage(movie);
              favoriteMovies.add(movie);
            }
          } on Exception {
            return false;
          }
          return true;
        }
      case 401:
        {
          return false;
        }
      case 404:
        {
          return false;
        }
      default:
        {
          return false;
        }
    }
  }

  Future<bool> setFavoriteMovie(int id, String sessionID) async {
    final response = await http.post(
        Uri.parse("https://api.themoviedb.org/3/account/" +
            MyConstants.ACCOUNT_ID +
            "/favorite?api_key=" +
            MyConstants.API_Key +
            "&session_id=" +
            sessionID),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'media_type': 'movie', 'media_id': id, 'favorite': true}));
    switch (response.statusCode) {
      case 201:
        {
          return true;
        }
      case 401:
        {
          return false;
        }
      case 404:
        {
          return false;
        }
      default:
        {
          return false;
        }
    }

    //https://developers.themoviedb.org/3/account/mark-as-favorite
  }
}
