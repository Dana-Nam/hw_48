import 'package:flutter/material.dart';
import '../providers/favorites_provider.dart';
import '../widgets/favorite_item.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoritesProvider.of(context)!;
    final favorites = provider.favorites;

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
            onRemove: () {
              provider.remove(joke.id);
              setState(() {});
            },
          );
        },
      ),
    );
  }
}
