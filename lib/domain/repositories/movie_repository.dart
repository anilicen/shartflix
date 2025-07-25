import 'package:shartflix/domain/entities/movie.dart';

abstract class MovieRepository {
  List<Movie> get movies;
  Future<void> getMovies({int page = 1});
  Future<List<Movie>> getfavoriteMovies();
}
