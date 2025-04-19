import 'package:flutter/material.dart';
import '../models/joke_model.dart';

class FavoritesProvider extends InheritedWidget {
  final List<Joke> favorites;
  final void Function(Joke joke) add;
  final void Function(String id) remove;

  const FavoritesProvider({
    super.key,
    required this.favorites,
    required this.add,
    required this.remove,
    required super.child,
  });

  static FavoritesProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FavoritesProvider>();
  }

  @override
  bool updateShouldNotify(covariant FavoritesProvider oldWidget) {
    return oldWidget.favorites.length != favorites.length;
  }
}
