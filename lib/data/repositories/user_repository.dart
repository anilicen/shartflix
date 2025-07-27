import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shartflix/core/services/logger_service.dart';
import 'package:shartflix/core/services/secure_storage_service.dart';
import 'package:shartflix/domain/entities/user.dart';
import 'package:shartflix/domain/repositories/user_repository.dart';

class DataUserRepository implements UserRepository {
  static final _instance = DataUserRepository._internal();
  DataUserRepository._internal();
  factory DataUserRepository() => _instance;

  final String _baseUrl = 'https://caseapi.servicelabs.tech';
  final Dio _dio = Dio();
  final LoggerService _logger = LoggerService();
  final ISecureStorageService _secureStorage = SecureStorageService();
  User? _currentUser;

  @override
  User? get currentUser => _currentUser;

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
          await getUserProfile(); // Fetch user profile after login
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
        _currentUser = User.fromJson(response.data['data'] as Map<String, dynamic>);
        _logger.debug('Current user profile: ${_currentUser?.toJson()}');

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

  @override
  Future<void> addPhoto(File file) async {
    final url = '$_baseUrl/user/upload_photo/';

    try {
      final token = await getAuthToken();
      if (token == null) {
        _logger.warning('No auth token found for add photo request');
        throw Exception('User not authenticated');
      }

      _logger.info('Uploading photo');
      _logger.debug('Request URL: $url');
      _logger.debug('File path: ${file.path}');
      _logger.debug('File exists: ${await file.exists()}');
      _logger.debug('File size: ${await file.length()} bytes');

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
        ),
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Remove Content-Type header - let Dio set it automatically for multipart
          },
        ),
      );

      _logger.debug('Add photo response: ${response.statusCode} - ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        _logger.info('Photo uploaded successfully');
        _currentUser = _currentUser!.copyWith(
          photoUrl: response.data['data']['photoUrl'] as String?,
        );
      } else {
        _logger.warning('Failed to upload photo with status code: ${response.statusCode}');
        throw Exception('Failed to upload photo with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _logger.error('HTTP Error ${e.response!.statusCode}: ${e.response!.statusMessage}');
        _logger.error('Response data: ${e.response!.data}');
        _logger.error('Request headers: ${e.requestOptions.headers}');
        _logger.error('Request data type: ${e.requestOptions.data.runtimeType}');

        // More specific error message based on status code
        String errorMessage = 'Failed to upload photo';
        if (e.response!.statusCode == 400) {
          errorMessage = 'Invalid photo format or size - please try a different image';
        } else if (e.response!.statusCode == 401) {
          errorMessage = 'Unauthorized - please login again';
          await logout(); // Clear invalid token
        } else if (e.response!.statusCode == 413) {
          errorMessage = 'Photo file is too large - please choose a smaller image';
        } else if (e.response!.statusCode == 415) {
          errorMessage = 'Unsupported image format - please use JPG, PNG, or WEBP';
        } else if (e.response!.statusCode == 500) {
          errorMessage = 'Server error - please try again later';
        }

        throw Exception(errorMessage);
      } else {
        _logger.error('Network error: ${e.message}', e);
        throw Exception('Network error: ${e.message}');
      }
    } catch (e, stackTrace) {
      _logger.error('Failed to upload photo', e, stackTrace);
      throw Exception('Failed to upload photo: ${e.toString()}');
    }
  }

  // Token management methods
  @override
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

  @override
  Future<void> logout() async {
    try {
      await _secureStorage.delete(_tokenKey);
      _logger.info('User logged out successfully - tokens cleared');
    } catch (e) {
      _logger.error('Failed to logout', e);
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>?> getUserProfile() async {
    final url = '$_baseUrl/user/profile';

    try {
      // Get the stored auth token
      final token = await getAuthToken();
      if (token == null) {
        _logger.warning('No auth token found for profile request');
        throw Exception('User not authenticated');
      }

      _logger.info('Fetching user profile');
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

      _logger.debug('Profile response: ${response.statusCode} - ${response.data}');

      _currentUser = User.fromJson(response.data['data'] as Map<String, dynamic>);
      _logger.debug('Current user profile: ${_currentUser?.toJson()}');

      if (response.statusCode == 200) {
        _logger.info('User profile retrieved successfully');
        return response.data as Map<String, dynamic>?;
      } else {
        _logger.warning('Failed to get profile with status code: ${response.statusCode}');
        throw Exception('Failed to get profile with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _logger.error('HTTP Error ${e.response!.statusCode}: ${e.response!.statusMessage}');
        _logger.error('Response data: ${e.response!.data}');

        // More specific error message based on status code
        String errorMessage = 'Failed to get profile';
        if (e.response!.statusCode == 401) {
          errorMessage = 'Unauthorized - please login again';
          // Clear invalid token
          await logout();
        } else if (e.response!.statusCode == 403) {
          errorMessage = 'Access forbidden';
        } else if (e.response!.statusCode == 404) {
          errorMessage = 'Profile not found';
        } else if (e.response!.statusCode == 500) {
          errorMessage = 'Server error - please try again later';
        }

        throw Exception(errorMessage);
      } else {
        _logger.error('Network error: ${e.message}', e);
        throw Exception('Network error: ${e.message}');
      }
    } catch (e, stackTrace) {
      _logger.error('Unexpected error during profile fetch', e, stackTrace);
      throw Exception('Failed to get profile: ${e.toString()}');
    }
  }

  @override
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
