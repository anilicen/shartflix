import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/domain/entities/movie.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';

class DiscoverController extends Controller {
  DiscoverController(MovieRepository movieRepository) : _movieRepository = movieRepository;
  final MovieRepository _movieRepository;
  List<Movie>? movies;
  int moviePerPage = 5;
  int? savedIndex;
  final Set<int> _loadedPages = {};
  final Map<int, bool> _expandedDescriptions = {};
  final Map<int, bool> _likedMovies = {};

  // Animation properties
  AnimationController? _likeAnimationController;
  Animation<double>? _likeAnimation;

  @override
  Future<void> onInitState() async {
    super.onInitState();

    getSavedIndex();
    if (savedIndex == null) {
      await _movieRepository.getMovies(page: 1);
      _loadedPages.add(1); // Mark page 1 as loaded
    }
    movies = _movieRepository.movies;
    refreshUI();
  }

  @override
  void initListeners() {
    // TODO: implement initListeners
  }

  @override
  void onDisposed() {
    disposeLikeAnimation();
    super.onDisposed();
  }

  void saveIndex(int index) {
    _movieRepository.saveIndex(index);
  }

  void getSavedIndex() {
    savedIndex = _movieRepository.getSavedIndex();
  }

  Future<void> getMovies(int index) async {
    if (index % 5 == 0) {
      int pageToLoad = index ~/ moviePerPage + 2;

      if (!_loadedPages.contains(pageToLoad)) {
        await _movieRepository.getMovies(page: pageToLoad);
        movies = _movieRepository.movies;
        _loadedPages.add(pageToLoad);
        refreshUI();
      }
    }
  }

  String getTruncatedText(String text, double maxWidth) {
    const textStyle = TextStyle(fontSize: 13);
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxWidth);

    if (!textPainter.didExceedMaxLines) {
      return text;
    }

    const showMoreText = " Show more";
    final showMorePainter = TextPainter(
      text: const TextSpan(text: showMoreText, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    showMorePainter.layout();

    final availableWidth = maxWidth - showMorePainter.width;

    final truncatedPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );
    truncatedPainter.layout(maxWidth: availableWidth);

    final truncatedText = text.substring(
        0, truncatedPainter.getPositionForOffset(Offset(availableWidth, truncatedPainter.height - 1)).offset);

    return truncatedText.trimRight();
  }

  bool needsShowMore(String text, double maxWidth) {
    const textStyle = TextStyle(fontSize: 13);
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.didExceedMaxLines;
  }

  bool isDescriptionExpanded(int index) {
    return _expandedDescriptions[index] == true;
  }

  void toggleDescriptionExpansion(int index) {
    _expandedDescriptions[index] = !(_expandedDescriptions[index] ?? false);
    refreshUI();
  }

  bool isMovieLiked(int index) {
    return _likedMovies[index] == true;
  }

  void toggleMovieLike(int index) {
    _likedMovies[index] = !(_likedMovies[index] ?? false);
    refreshUI();
  }

  void initializeLikeAnimation(TickerProvider vsync) {
    if (_likeAnimationController == null) {
      _likeAnimationController = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: vsync,
      );
      _likeAnimation = Tween<double>(
        begin: 1.0,
        end: 1.3,
      ).animate(CurvedAnimation(
        parent: _likeAnimationController!,
        curve: Curves.elasticOut,
      ));
    }
  }

  void triggerLikeAnimation() {
    _likeAnimationController?.forward().then((_) {
      _likeAnimationController?.reverse();
    });
  }

  Animation<double>? get likeAnimation => _likeAnimation;

  void disposeLikeAnimation() {
    _likeAnimationController?.dispose();
    _likeAnimationController = null;
    _likeAnimation = null;
  }
}
