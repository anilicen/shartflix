import 'dart:io';

abstract class UserRepository {
  Future<void> login(String email, String password);
  Future<void> register(String username, String password, String email);
  Future<void> addPhoto(File file);
  Future<String?> getAuthToken();
  Future<void> logout();
  Future<Map<String, dynamic>?> getUserProfile();
  Future<bool> isLoggedIn();
}
