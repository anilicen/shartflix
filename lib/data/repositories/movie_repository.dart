import 'package:dio/dio.dart';
import 'package:shartflix/core/services/logger_service.dart';
import 'package:shartflix/core/services/secure_storage_service.dart';
import 'package:shartflix/domain/entities/movie.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';

class DataMovieRepository implements MovieRepository {
  static final _instance = DataMovieRepository._internal();
  DataMovieRepository._internal();
  factory DataMovieRepository() => _instance;

  final String _baseUrl = 'https://caseapi.servicelabs.tech';
  final Dio _dio = Dio();
  final LoggerService _logger = LoggerService();
  final ISecureStorageService _secureStorage = SecureStorageService();
  final List<Movie> _movies = [];
  final List<Movie> _favoriteMovies = [];
  final int moviePerPage = 5;
  int? _savedIndex;

  @override
  List<Movie> get movies => _movies;

  @override
  List<Movie> get favoriteMovies => _favoriteMovies;

  static const String _tokenKey = 'auth_token';

  /// Fixes IMDB URLs by changing HTTPS to HTTP to avoid 403 errors
  String _fixImdbUrl(String originalUrl) {
    // If it's an IMDB URL with HTTPS, change it to HTTP
    if (originalUrl.contains('http://ia.media-imdb.com')) {
      return originalUrl.replaceFirst('http://', 'https://');
    }

    // Return original URL if it's not an IMDB HTTPS URL
    return originalUrl;
  }

  @override
  void saveIndex(int index) {
    _savedIndex = index;
  }

  @override
  int? getSavedIndex() {
    return _savedIndex;
  }

  @override
  Future<void> getMovies({int page = 1}) async {
    if (moviePerPage * (page - 1) < _movies.length) return;
    final url = '$_baseUrl/movie/list/';

    try {
      // Get the stored auth token
      final token = await _secureStorage.read(_tokenKey);
      if (token == null) {
        _logger.warning('No auth token found for movies request');
        throw Exception('User not authenticated - please login first');
      }

      _logger.info('Fetching movies - Page: $page');
      _logger.debug('Request URL: $url');

      final response = await _dio.get(
        url,
        queryParameters: {
          'page': page,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      _logger.debug('Movies response: ${response.statusCode} - ${response.data}');
      if (response.statusCode == 200) {
        _logger.info('Movies retrieved successfully for page: $page');

        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final moviesData = responseData['data'] as Map<String, dynamic>?;
          if (moviesData != null) {
            final moviesList = moviesData['movies'] as List<dynamic>?;
            if (moviesList != null) {
              for (final movieJson in moviesList) {
                final movie = Movie.fromJson(movieJson as Map<String, dynamic>);
                // Fix IMDB URLs by changing HTTPS to HTTP
                final fixedMovie = movie.copyWith(
                  posterUrl: _fixImdbUrl(movie.posterUrl),
                );
                final isLikedFixedMovie = fixedMovie.copyWith(
                  isLiked: _favoriteMovies.any((fav) => fav.id == fixedMovie.id),
                );

                _movies.add(isLikedFixedMovie);
              }
            }
          }
        }
      } else {
        _logger.warning('Failed to get movies with status code: ${response.statusCode}');
        throw Exception('Failed to get movies with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _logger.error('HTTP Error ${e.response!.statusCode}: ${e.response!.statusMessage}');
        _logger.error('Response data: ${e.response!.data}');

        // More specific error message based on status code
        String errorMessage = 'Failed to get movies';
        if (e.response!.statusCode == 401) {
          errorMessage = 'Unauthorized - please login again';
        } else if (e.response!.statusCode == 403) {
          errorMessage = 'Access forbidden';
        } else if (e.response!.statusCode == 404) {
          errorMessage = 'Movies not found';
        } else if (e.response!.statusCode == 500) {
          errorMessage = 'Server error - please try again later';
        }

        throw Exception(errorMessage);
      } else {
        _logger.error('Network error: ${e.message}', e);
        throw Exception('Network error: ${e.message}');
      }
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during movies fetch', e, stackTrace);
      throw Exception('Failed to get movies: ${e.toString()}');
    }
  }

  @override
  Future<void> getFavoriteMovies() async {
    final url = '$_baseUrl/movie/favorites/';

    try {
      // Get the stored auth token
      final token = await _secureStorage.read(_tokenKey);
      if (token == null) {
        _logger.warning('No auth token found for favorite movies request');
        throw Exception('User not authenticated - please login first');
      }

      _logger.info('Fetching favorite movies');
      _logger.debug('Request URL: $url');

      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      _logger.debug('Favorite movies response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200) {
        _logger.info('Favorite movies retrieved successfully');

        final responseData = response.data;
        _favoriteMovies.clear(); // Clear existing favorites

        if (responseData is Map<String, dynamic>) {
          final dataField = responseData['data'];

          if (dataField == null || (dataField is List && dataField.isEmpty)) {
            _logger.info('No favorite movies found');
            return;
          }

          if (dataField is List<dynamic>) {
            for (final movieJson in dataField) {
              if (movieJson is Map<String, dynamic>) {
                final movie = Movie.fromJson(movieJson);
                final fixedMovie = movie.copyWith(
                  posterUrl: _fixImdbUrl(movie.posterUrl),
                  isLiked: true,
                );
                _favoriteMovies.add(fixedMovie);
              }
            }
          } else if (dataField is Map<String, dynamic>) {
            final moviesList = dataField['movies'] as List<dynamic>?;
            if (moviesList != null) {
              for (final movieJson in moviesList) {
                if (movieJson is Map<String, dynamic>) {
                  final movie = Movie.fromJson(movieJson);
                  // Fix IMDB URLs by changing HTTPS to HTTP
                  final fixedMovie = movie.copyWith(
                    posterUrl: _fixImdbUrl(movie.posterUrl),
                    isLiked: true,
                  );
                  _favoriteMovies.add(fixedMovie);
                }
              }
            }
          }
        }
      } else {
        _logger.warning('Failed to get favorite movies with status code: ${response.statusCode}');
        throw Exception('Failed to get favorite movies with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _logger.error('HTTP Error ${e.response!.statusCode}: ${e.response!.statusMessage}');
        _logger.error('Response data: ${e.response!.data}');

        // More specific error message based on status code
        String errorMessage = 'Failed to get favorite movies';
        if (e.response!.statusCode == 401) {
          errorMessage = 'Unauthorized - please login again';
        } else if (e.response!.statusCode == 403) {
          errorMessage = 'Access forbidden';
        } else if (e.response!.statusCode == 404) {
          errorMessage = 'Favorite movies not found';
        } else if (e.response!.statusCode == 500) {
          errorMessage = 'Server error - please try again later';
        }

        throw Exception(errorMessage);
      } else {
        _logger.error('Network error: ${e.message}', e);
        throw Exception('Network error: ${e.message}');
      }
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during favorite movies fetch', e, stackTrace);
      throw Exception('Failed to get favorite movies: ${e.toString()}');
    }
  }

  @override
  Future<void> toggleFavoriteMovie(String movieId) async {
    final url = '$_baseUrl/movie/favorite/$movieId';

    try {
      // Get the stored auth token
      final token = await _secureStorage.read(_tokenKey);
      if (token == null) {
        _logger.warning('No auth token found for toggle favorite request');
        throw Exception('User not authenticated - please login first');
      }

      final movieIndex = _movies.indexWhere((movie) => movie.id == movieId);
      if (movieIndex != -1) {
        final movie = _movies[movieIndex];
        final updatedMovie = movie.copyWith(isLiked: !movie.isLiked);
        _movies[movieIndex] = updatedMovie;

        // Update favorite movies list
        if (updatedMovie.isLiked) {
          if (!_favoriteMovies.any((fav) => fav.id == movieId)) {
            _favoriteMovies.add(updatedMovie);
          }
        } else {
          _favoriteMovies.removeWhere((fav) => fav.id == movieId);
        }
      }

      _logger.info('Toggling favorite status for movie: $movieId');
      _logger.debug('Request URL: $url');

      final response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      _logger.debug('Toggle favorite response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('Favorite status toggled successfully for movie: $movieId');
      } else {
        // If the post operation fails, revert the local changes
        if (movieIndex != -1) {
          final movie = _movies[movieIndex];
          final updatedMovie = movie.copyWith(isLiked: !movie.isLiked);
          _movies[movieIndex] = updatedMovie;

          // Update favorite movies list
          if (updatedMovie.isLiked) {
            if (!_favoriteMovies.any((fav) => fav.id == movieId)) {
              _favoriteMovies.add(updatedMovie);
            }
          } else {
            _favoriteMovies.removeWhere((fav) => fav.id == movieId);
          }
        }
        _logger.warning('Failed to toggle favorite with status code: ${response.statusCode}');
        throw Exception('Failed to toggle favorite with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _logger.error('HTTP Error ${e.response!.statusCode}: ${e.response!.statusMessage}');
        _logger.error('Response data: ${e.response!.data}');

        // More specific error message based on status code
        String errorMessage = 'Failed to toggle favorite';
        if (e.response!.statusCode == 401) {
          errorMessage = 'Unauthorized - please login again';
        } else if (e.response!.statusCode == 403) {
          errorMessage = 'Access forbidden';
        } else if (e.response!.statusCode == 404) {
          errorMessage = 'Movie not found';
        } else if (e.response!.statusCode == 500) {
          errorMessage = 'Server error - please try again later';
        }

        throw Exception(errorMessage);
      } else {
        _logger.error('Network error: ${e.message}', e);
        throw Exception('Network error: ${e.message}');
      }
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during toggle favorite', e, stackTrace);
      throw Exception('Failed to toggle favorite: ${e.toString()}');
    }
  }
}



// Usage