import 'dart:io';

import 'package:shartflix/domain/entities/user.dart';

abstract class UserRepository {
  Future<void> login(String email, String password);
  Future<void> signInWithGoogle({
    required String idToken,
    required String accessToken,
    required String email,
    required String displayName,
    required String photoUrl,
  });
  Future<void> signInWithFacebook({
    required String accessToken,
    required String email,
    required String displayName,
    required String photoUrl,
  });
  Future<void> register(String username, String password, String email);
  Future<void> addPhoto(File file);
  Future<String?> getAuthToken();
  Future<void> logout();
  Future<Map<String, dynamic>?> getUserProfile();
  Future<bool> isLoggedIn();
  User? get currentUser;
}
