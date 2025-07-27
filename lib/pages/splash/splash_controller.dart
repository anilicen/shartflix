import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/domain/repositories/user_repository.dart';
import 'package:shartflix/navigator.dart';

class SplashController extends Controller {
  SplashController(UserRepository userRepository) : _userRepository = userRepository;

  final UserRepository _userRepository;

  @override
  void initListeners() {
    // Initialize listeners if needed
  }

  @override
  Future<void> onInitState() async {
    super.onInitState();

    // Add a delay for splash screen effect
    await Future.delayed(const Duration(seconds: 2));

    // Check if user is already logged in
    await _checkUserLoginStatus();
  }

  Future<void> _checkUserLoginStatus() async {
    try {
      // Try to get user profile from repository
      await _userRepository.getUserProfile();

      // If user exists, navigate to main view
      if (_userRepository.currentUser != null) {
        ShartflixNavigator.navigateToMainView(getContext());
      } else {
        // If no user, navigate to login view
        ShartflixNavigator.navigateToLoginView(getContext());
      }
    } catch (e) {
      // If there's an error getting user profile, navigate to login
      ShartflixNavigator.navigateToLoginView(getContext());
    }
  }
}
