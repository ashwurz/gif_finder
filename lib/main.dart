import 'package:flutter/material.dart';
import 'package:buscador_gif/ui/home_page.dart';

void main(){
  runApp(MaterialApp(
    home: HomePage(),
    title: "Buscador GIF",
    theme: ThemeData(hintColor: Colors.white,canvasColor: Colors.black),
  ));
}