import 'package:flutter/material.dart';
import 'screens/jokes_screen.dart';
import 'screens/favorites_screen.dart';
import 'providers/favorites_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FavoritesState(
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => JokesScreen(),
          '/favorites': (context) => FavoritesScreen(),
        },
      ),
    );
  }
}
