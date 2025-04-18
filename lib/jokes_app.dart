import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JokesApp extends StatefulWidget {
  const JokesApp({super.key});

  @override
  State<JokesApp> createState() => _JokesAppState();
}

class _JokesAppState extends State<JokesApp> {
  String? jokeText;
  int favoritesCount = 0;

  Future<void> fetchJoke() async {
    final response =
        await http.get(Uri.parse('https://v2.jokeapi.dev/joke/any'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        if (data['type'] == 'single') {
          jokeText = data['joke'];
        } else {
          jokeText = '${data['setup']}\n\n${data['delivery']}';
        }
      });
    }
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
                onPressed: () {},
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
            Expanded(
              child: Center(
                child: Text(
                  jokeText ?? 'Загрузка...',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
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
                    onPressed: () {},
                    child: Text('В избранное'),
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
