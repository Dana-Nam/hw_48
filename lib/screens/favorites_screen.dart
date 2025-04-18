import 'package:flutter/material.dart';
import '../models/joke_model.dart';
import '../widgets/favorite_item.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Joke> favorites;
  final void Function(String id) onRemove;

  const FavoritesScreen({
    super.key,
    required this.favorites,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Избранные (${favorites.length})'),
      ),
      body: ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final joke = favorites[index];
          return FavoriteItem(
            joke: joke,
            onRemove: () => onRemove(joke.id),
          );
        },
      ),
    );
  }
}
