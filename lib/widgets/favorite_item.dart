import 'package:flutter/material.dart';
import '../models/joke_model.dart';

class FavoriteItem extends StatelessWidget {
  final Joke joke;
  final VoidCallback onRemove;

  const FavoriteItem({
    super.key,
    required this.joke,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            joke.content,
            style: TextStyle(fontSize: 16),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: onRemove,
          ),
        ),
      ),
    );
  }
}
