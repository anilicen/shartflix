import 'package:shartflix/domain/entities/movie.dart';

abstract class MovieRepository {
  List<Movie> get movies;
  List<Movie> get favoriteMovies;
  Future<void> getMovies({int page = 1});
  void saveIndex(int index);
  int? getSavedIndex();
  Future<void> getFavoriteMovies();
  Future<void> toggleFavoriteMovie(String movieId);
}
