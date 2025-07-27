class Movie {
  final String id;
  final String title;
  final String description;
  final String posterUrl;
  final String director;
  final bool isLiked;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.posterUrl,
    required this.director,
    this.isLiked = false,
  });

  Movie copyWith({
    String? id,
    String? title,
    String? description,
    String? posterUrl,
    String? director,
    bool? isLiked,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      posterUrl: posterUrl ?? this.posterUrl,
      director: director ?? this.director,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as String,
      title: json['Title'] as String,
      description: json['Plot'] as String,
      posterUrl: json['Poster'] as String,
      director: json['Director'] as String? ?? 'Unknown',
      isLiked: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'posterUrl': posterUrl,
      'director': director,
      'isLiked': isLiked,
    };
  }
}
