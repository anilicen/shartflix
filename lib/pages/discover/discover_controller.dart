import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/domain/entities/movie.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';

class DiscoverController extends Controller {
  DiscoverController(MovieRepository movieRepository) : _movieRepository = movieRepository;
  final MovieRepository _movieRepository;

  List<Movie>? movies;
  @override
  Future<void> onInitState() async {
    super.onInitState();
    await _movieRepository.getMovies(page: 1);
    movies = _movieRepository.movies;
    refreshUI();
  }

  void getMovies() {}

  @override
  void initListeners() {
    // TODO: implement initListeners
  }
}
