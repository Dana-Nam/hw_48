import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/joke_model.dart';
import 'favorites_provider.dart';

class FavoritesState extends StatefulWidget {
  final Widget child;

  const FavoritesState({super.key, required this.child});

  @override
  State<FavoritesState> createState() => _FavoritesStateState();
}

class _FavoritesStateState extends State<FavoritesState> {
  List<Joke> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    print('Loading favorites...');
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList('favorites') ?? [];
    print('Loaded raw list: $stored');
    final jokes = stored.map((j) => Joke.fromLocalJson(jsonDecode(j))).toList();
    setState(() {
      favorites = jokes;
    });
    print('Parsed favorites: ${favorites.length}');
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = favorites.map((j) => jsonEncode(j.toJson())).toList();
    await prefs.setStringList('favorites', list);
    print('Saved favorites: $list');
  }

  void add(Joke joke) {
    if (!favorites.any((j) => j.id == joke.id)) {
      setState(() {
        favorites.add(joke.copyWith(isFavorite: true));
      });
      saveFavorites();
    }
  }

  void remove(String id) {
    setState(() {
      favorites.removeWhere((j) => j.id == id);
    });
    saveFavorites();
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
