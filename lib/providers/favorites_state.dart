import 'package:flutter/material.dart';
import '../models/joke_model.dart';
import 'favorites_provider.dart';

class FavoritesState extends StatefulWidget {
  final Widget child;

  const FavoritesState({super.key, required this.child});

  @override
  State<FavoritesState> createState() => _FavoritesStateState();
}

class _FavoritesStateState extends State<FavoritesState> {
  final List<Joke> favorites = [];

  void add(Joke joke) {
    if (!favorites.any((j) => j.id == joke.id)) {
      setState(() {
        favorites.add(joke.copyWith(isFavorite: true));
      });
    }
  }

  void remove(String id) {
    setState(() {
      favorites.removeWhere((j) => j.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FavoritesProvider(
      favorites: favorites,
      add: add,
      remove: remove,
      child: widget.child,
    );
  }
}
