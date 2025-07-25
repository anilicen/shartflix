import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/domain/entities/movie.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';
import 'package:shartflix/domain/repositories/user_repository.dart';

class DiscoverController extends Controller {
  DiscoverController(MovieRepository movieRepository, UserRepository userRepository)
      : _movieRepository = movieRepository,
        _userRepository = userRepository;

  final UserRepository _userRepository;
  final MovieRepository _movieRepository;

  List<Movie>? movies;
  String? token;
  @override
  Future<void> onInitState() async {
    super.onInitState();
    await _movieRepository.getMovies(page: 1);
    movies = _movieRepository.movies;
    token = await _userRepository.getAuthToken();
    refreshUI();
  }

  void getMovies() {}

  @override
  void initListeners() {
    // TODO: implement initListeners
  }
}
