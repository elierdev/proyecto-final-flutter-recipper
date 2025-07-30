// pubspec.yaml dependencies needed:
// flutter:
//   sdk: flutter
// sqflite: ^2.3.0
// path: ^1.8.3
// cached_network_image: ^3.3.0
// share_plus: ^7.2.1
// image_picker: ^1.0.4

import 'package:flutter/material.dart';


import 'pages/home_page.dart';



void main() {
  runApp(RecetasApp());
}

class RecetasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recetas Deliciosas',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Color(0xFFFF6B35),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFF6B35),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
