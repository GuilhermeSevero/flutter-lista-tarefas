import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      title: 'Lista Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          backgroundColor: Colors.white,
          primaryColor: Colors.blueAccent,
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent,
            textTheme: ButtonTextTheme.primary,
          )),
    );
  }
}
