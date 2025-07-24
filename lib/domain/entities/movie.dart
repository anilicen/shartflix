class Movie {
  final String id;
  final String title;
  final String description;
  final String posterUrl;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
    );
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['Title'] as String,
      description: json['Plot'] as String,
      posterUrl: json['Poster'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'posterUrl': posterUrl,
    };
  }
}
