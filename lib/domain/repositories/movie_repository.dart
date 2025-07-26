import 'package:shartflix/domain/entities/movie.dart';

abstract class MovieRepository {
  List<Movie> get movies;
  Future<void> getMovies({int page = 1});
  void saveIndex(int index);
  int? getSavedIndex();
  Future<List<Movie>> getfavoriteMovies();
}
