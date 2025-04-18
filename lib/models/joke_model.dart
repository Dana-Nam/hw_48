class Joke {
  final String id;
  final String content;
  final bool isFavorite;

  Joke({
    required this.id,
    required this.content,
    this.isFavorite = false,
  });

  factory Joke.fromJson(Map<String, dynamic> json) {
    String text;
    if (json['type'] == 'single') {
      text = json['joke'];
    } else {
      text = '${json['setup']}\n\n${json['delivery']}';
    }

    return Joke(
      id: json['id'].toString(),
      content: text,
    );
  }

  Joke copyWith({bool? isFavorite}) {
    return Joke(
      id: id,
      content: content,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
