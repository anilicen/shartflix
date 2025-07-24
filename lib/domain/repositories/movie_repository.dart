import 'package:shartflix/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies({int page = 1});
  Future<List<Movie>> getfavoriteMovies();
}
