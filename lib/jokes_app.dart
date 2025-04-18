import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/joke_model.dart';
import 'widgets/joke_card.dart';
import 'screens/favorites_screen.dart';

class JokesApp extends StatefulWidget {
  const JokesApp({super.key});

  @override
  State<JokesApp> createState() => _JokesAppState();
}

class _JokesAppState extends State<JokesApp> {
  Joke? currentJoke;
  List<Joke> favorites = [];

  Future<void> fetchJoke() async {
    final response =
        await http.get(Uri.parse('https://v2.jokeapi.dev/joke/any'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newJoke = Joke.fromJson(data);
      final alreadyFavorite = favorites.any((j) => j.id == newJoke.id);
      setState(() {
        currentJoke = newJoke.copyWith(isFavorite: alreadyFavorite);
      });
    }
  }

  void toggleFavorite() {
    if (currentJoke == null) return;
    final exists = favorites.any((j) => j.id == currentJoke!.id);
    setState(() {
      if (exists) {
        favorites.removeWhere((j) => j.id == currentJoke!.id);
        currentJoke = currentJoke!.copyWith(isFavorite: false);
      } else {
        favorites.add(currentJoke!.copyWith(isFavorite: true));
        currentJoke = currentJoke!.copyWith(isFavorite: true);
      }
    });
  }

  void removeFromFavorites(String id) {
    setState(() {
      favorites.removeWhere((j) => j.id == id);
      if (currentJoke?.id == id) {
        currentJoke = currentJoke!.copyWith(isFavorite: false);
      }
    });
  }

  void openFavoritesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FavoritesScreen(
          favorites: favorites,
          onRemove: removeFromFavorites,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchJoke();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Шутки'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: openFavoritesScreen,
              ),
              Positioned(
                right: 6,
                top: 6,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    '${favorites.length}',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentJoke != null)
              JokeCard(joke: currentJoke!)
            else
              Expanded(child: Center(child: CircularProgressIndicator())),
            SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: fetchJoke,
                    child: Text('Следующая'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: toggleFavorite,
                    child: Text(
                      currentJoke?.isFavorite == true
                          ? 'Убрать из избранного'
                          : 'Добавить в избранное',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
