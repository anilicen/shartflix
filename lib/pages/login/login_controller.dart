import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/domain/repositories/user_repository.dart';

class LoginController extends Controller {
  LoginController(UserRepository userRepository) : _userRepository = userRepository;

  final UserRepository _userRepository;

  String email = '';
  String password = '';
  bool isObscurePassword = true;

  String? emailError;
  String? loginError;

  bool isLoading = false;

  // Email regex pattern
  static const String _emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static final RegExp _emailRegex = RegExp(_emailPattern);
  void onEmailChanged(String value) {
    email = value;
    loginError = null; // Reset login error on email change
    refreshUI();
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  bool get isEmailValid => emailError == null && email.isNotEmpty;

  void onPasswordChanged(String value) {
    password = value;
    loginError = null; // Reset login error on password change
    refreshUI();
  }

  void toggleObscurePassword() {
    isObscurePassword = !isObscurePassword;
    refreshUI();
  }

  Future<void> login() async {
    isLoading = true;
    refreshUI();

    emailError = _validateEmail(email);

    // Validate email before attempting login
    if (!isEmailValid) {
      // Handle invalid email - you might want to show an error message
      loginError = 'Invalid email: $emailError';
      isLoading = false;
      refreshUI();
      return;
    }

    if (password.isEmpty) {
      loginError = 'Password is required';
      isLoading = false;
      refreshUI();
      return;
    }

    // Proceed with login if validation passes
    try {
      await _userRepository.login(email, password);
    } catch (e) {
      loginError = 'Login failed: ${e.toString()}';
    }
    isLoading = false;
    refreshUI();
    return;
  }

  @override
  void initListeners() {
    // TODO: implement initListeners
  }
}
