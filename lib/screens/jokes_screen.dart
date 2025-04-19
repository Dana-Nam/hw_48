import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/joke_model.dart';
import '../providers/favorites_provider.dart';
import '../widgets/joke_card.dart';

class JokesScreen extends StatefulWidget {
  const JokesScreen({super.key});

  @override
  State<JokesScreen> createState() => _JokesScreenState();
}

class _JokesScreenState extends State<JokesScreen> {
  Joke? currentJoke;

  Future<void> fetchJoke() async {
    final response =
        await http.get(Uri.parse('https://v2.jokeapi.dev/joke/any'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final joke = Joke.fromJson(data);
      final isFav = FavoritesProvider.of(context)
              ?.favorites
              .any((j) => j.id == joke.id) ??
          false;
      setState(() {
        currentJoke = joke.copyWith(isFavorite: isFav);
      });
    }
  }

  void toggleFavorite() {
    if (currentJoke == null) return;
    final provider = FavoritesProvider.of(context);
    final exists =
        provider?.favorites.any((j) => j.id == currentJoke!.id) ?? false;
    if (exists) {
      provider?.remove(currentJoke!.id);
    } else {
      provider?.add(currentJoke!);
    }
    setState(() {
      currentJoke = currentJoke!.copyWith(isFavorite: !exists);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchJoke();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesCount = FavoritesProvider.of(context)?.favorites.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Шутки'),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.pushNamed(context, '/favorites');
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.red,
                  child: Text(
                    '$favoritesCount',
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
