import 'dart:html';

import 'package:chicoguesser/colors.dart';
import 'package:flutter/material.dart';
import 'package:chicoguesser/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChicoGuesser',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomeScreen(),
    );
  }
}
