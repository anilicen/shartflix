import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/domain/entities/movie.dart';
import 'package:shartflix/domain/entities/user.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';
import 'package:shartflix/domain/repositories/user_repository.dart';
import 'package:shartflix/navigator.dart';
import 'package:shartflix/core/language_notifier.dart';

class ProfileController extends Controller {
  ProfileController(UserRepository userRepository, MovieRepository movieRepository)
      : _userRepository = userRepository,
        _movieRepository = movieRepository;

  final UserRepository _userRepository;
  final MovieRepository _movieRepository;
  StreamSubscription? _languageSubscription;

  User? user;
  List<Movie>? favoriteMovies;

  @override
  void initListeners() {
    // Listen for language changes and refresh UI
    _languageSubscription = LanguageNotifier().languageStream.listen((_) {
      refreshUI();
    });
  }

  @override
  void onInitState() {
    super.onInitState();
    if (user == null) {
      getUser();
      refreshUI();
    }
    getFavoriteMovies();
    refreshUI();

    // Perform any initial setup here
  }

  void getUser() {
    user = _userRepository.currentUser;
  }

  void getFavoriteMovies() {
    favoriteMovies = _movieRepository.favoriteMovies;
    refreshUI();
  }

  Future<void> navigateToLanguageSettingsView(BuildContext context) async {
    await ShartflixNavigator.navigateToLanguageSettingsView(context);
    refreshUI();
  }

  Future<void> navigateToAddPhotoView(BuildContext context) async {
    await ShartflixNavigator.navigateToAddPhotoView(context);
    // Refresh user data after returning from add photo view
    getUser();
    refreshUI();
  }

  @override
  void onDisposed() {
    _languageSubscription?.cancel();
    super.onDisposed();
  }
}
