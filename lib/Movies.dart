import 'package:flutter/material.dart';

class Movies
{
  String name='';
  int id=0;
  String posterPath='';
  bool isLiked = false;
  Image img = Image.asset('logo.png');

  Movies();
  Movies.named(this.name,this.isLiked,this.id,this.posterPath);
}