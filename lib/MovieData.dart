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

  Future<String> getTopRatedMovies() async {
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
              movies.add(movie);
              movie.img = await getImage(movie);
            }

            if (movies.isNotEmpty) {
              return "OK";
            } else {
              return "ErrorFailed";
            }
          } on Exception {
            return "ErrorException";
          }
        }
      case 401:
        {
          return "Error401";
        }
      case 404:
        {
          return "Error404";
        }
      default:
        {
          return "ErrorX";
        }
    }
  }

  Future<Image> getImage(Movies movie) async {
    return Image.network(Uri.parse(baseUrl + sizes[3] + movie.posterPath).toString());
  }

  Future<String> getFavoriteMovies() async {
    return "OK";
    //https://developers.themoviedb.org/3/account/get-favorite-movies
  }

  Future<String> setFavoriteMovie(int id) async {
    final response = await http.post(
        Uri.parse(
            "https://api.themoviedb.org/3/account/"+MyConstants.ACCOUNT_ID+"/favorite?api_key=" + MyConstants.API_Key+"&session_id="),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'media_type':'movie','media_id':id,'favorite':true})
    );
    print(response.body);
    switch (response.statusCode) {
      case 200:
        {
          return "OK";
        }
      case 401:
        {
          return "Error401";
        }
      case 404:
        {
          return "Error404";
        }
      default:
        {
          return "ErrorX";
        }
    }

    //https://developers.themoviedb.org/3/account/mark-as-favorite
  }
}
