import 'package:final_project/Screen/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(),
    darkTheme: ThemeData.dark(),
    debugShowCheckedModeBanner: false,
    home: MainScreen(),
  ));
}
