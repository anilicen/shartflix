import 'package:dio/dio.dart';
import 'package:shartflix/core/services/logger_service.dart';
import 'package:shartflix/core/services/secure_storage_service.dart';
import 'package:shartflix/domain/entities/movie.dart';
import 'package:shartflix/domain/repositories/movie_repository.dart';

class DataMovieRepository implements MovieRepository {
  final String _baseUrl = 'https://caseapi.servicelabs.tech';
  final Dio _dio = Dio();
  final LoggerService _logger = LoggerService();
  final ISecureStorageService _secureStorage = SecureStorageService();
  final List<Movie> _movies = [];

  @override
  List<Movie> get movies => _movies;

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
  Future<void> getMovies({int page = 1}) async {
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
                _movies.add(fixedMovie);
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
  Future<List<Movie>> getfavoriteMovies() async {
    final url = '$_baseUrl/favorite-movies';
    // Implement the logic to fetch favorite movies from the API
    // ...
    return [];
  }
}



// Usage