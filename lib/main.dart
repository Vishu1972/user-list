import 'package:flutter/material.dart';
import 'package:userdetails/userdetail.dart';
void main() {
  runApp(myapp());
}
class myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Sample app",
        debugShowCheckedModeBanner: false,
        darkTheme: ThemeData(
        ),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomeScreen()
    );
  }
}
