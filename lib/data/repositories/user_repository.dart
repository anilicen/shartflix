import 'package:dio/dio.dart';
import 'package:shartflix/core/services/logger_service.dart';
import 'package:shartflix/core/services/secure_storage_service.dart';
import 'package:shartflix/domain/repositories/user_repository.dart';

class DataUserRepository implements UserRepository {
  final String _baseUrl = 'https://caseapi.servicelabs.tech';
  final Dio _dio = Dio();
  final LoggerService _logger = LoggerService();
  final ISecureStorageService _secureStorage = SecureStorageService();

  static const String _tokenKey = 'auth_token';

  @override
  Future<void> login(String email, String password) async {
    final url = '$_baseUrl/user/login/';

    _logger.info('Login attempt for email: $email');
    _logger.debug('Request URL: $url');

    try {
      final response = await _dio.post(
        url,
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      _logger.debug('Login response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('Login successful for email: $email');

        // Extract and save token from response
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final token = responseData['data']['token'] as String?;

          if (token != null) {
            await _secureStorage.write(_tokenKey, token);
            _logger.debug('Auth token saved successfully');
          }
        }
      } else {
        _logger.warning('Login failed with status code: ${response.statusCode}');
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _logger.error('HTTP Error ${e.response!.statusCode}: ${e.response!.statusMessage}');
        _logger.error('Response data: ${e.response!.data}');
        _logger.error('Request headers: ${e.requestOptions.headers}');
        _logger.error('Request data: ${e.requestOptions.data}');

        // More specific error message based on status code
        String errorMessage = 'Login failed';
        if (e.response!.statusCode == 400) {
          errorMessage = 'Invalid credentials - please check your username and password';
        } else if (e.response!.statusCode == 401) {
          errorMessage = 'Unauthorized - invalid username or password';
        } else if (e.response!.statusCode == 404) {
          errorMessage = 'User not found';
        } else if (e.response!.statusCode == 500) {
          errorMessage = 'Server error - please try again later';
        }

        throw Exception(errorMessage);
      } else {
        _logger.error('Network error: ${e.message}', e);
        throw Exception('Network error: ${e.message}');
      }
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during login', e, stackTrace);
      throw Exception('Failed to login: ${e.toString()}');
    }
  }

  @override
  Future<void> register(String username, String password, String email) async {
    final url = '$_baseUrl/user/register/';

    _logger.info('Starting user registration for username: $username');
    try {
      final response = await _dio.post(
        url,
        data: {
          'email': email,
          'name': username,
          'password': password,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      _logger.debug('Registration response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('User registration successful for username: $username');

        // Extract and save token from response
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          final token = responseData['data']['token'] as String?;

          if (token != null) {
            await _secureStorage.write(_tokenKey, token);
            _logger.debug('Auth token saved successfully');
          }
        }
      } else {
        _logger.warning('Registration failed with status code: ${response.statusCode}');
        throw Exception('Registration failed with status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to register user', e, stackTrace);
      throw Exception('Failed to register user: ${e.toString()}');
    }
  }

  // Token management methods
  Future<String?> getAuthToken() async {
    try {
      final token = await _secureStorage.read(_tokenKey);
      _logger.debug('Retrieved auth token: ${token != null ? 'exists' : 'null'}');
      return token;
    } catch (e) {
      _logger.error('Failed to retrieve auth token', e);
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _secureStorage.delete(_tokenKey);
      _logger.info('User logged out successfully - tokens cleared');
    } catch (e) {
      _logger.error('Failed to logout', e);
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final token = await getAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      _logger.error('Failed to check login status', e);
      return false;
    }
  }
}
