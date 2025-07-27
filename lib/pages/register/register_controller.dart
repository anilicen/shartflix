import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/domain/repositories/user_repository.dart';
import 'package:shartflix/navigator.dart';

class RegisterController extends Controller {
  RegisterController(UserRepository userRepository) : _userRepository = userRepository;
  final UserRepository _userRepository;
  String email = '';
  String password = '';
  String confirmPassword = '';
  String username = '';

  bool isObscurePassword = true;
  bool isObscureConfirmPassword = true;

  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? usernameError;
  String? registerError;

  bool isLoading = false;

  // Email regex pattern
  static const String _emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static final RegExp _emailRegex = RegExp(_emailPattern);

  void onEmailChanged(String value) {
    email = value;
    registerError = null; // Reset register error on email change
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
    registerError = null; // Reset register error on password change
    refreshUI();
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  bool get isPasswordValid => passwordError == null && password.isNotEmpty;

  void onConfirmPasswordChanged(String value) {
    confirmPassword = value;
    registerError = null; // Reset register error on confirm password change
    refreshUI();
  }

  String? _validateConfirmPassword(String confirmPassword) {
    if (confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (confirmPassword != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  bool get isConfirmPasswordValid => confirmPasswordError == null && confirmPassword.isNotEmpty;

  void onUsernameChanged(String value) {
    username = value;
    registerError = null; // Reset register error on username change
    refreshUI();
  }

  String? _validateUsername(String username) {
    if (username.isEmpty) {
      return 'Name is required';
    }
    if (username.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  bool get isUsernameValid => usernameError == null && username.isNotEmpty;

  void navigateToLoginView(BuildContext context) {
    ShartflixNavigator.navigateToLoginView(context);
    // refreshUI();
  }

  void toggleObscurePassword() {
    isObscurePassword = !isObscurePassword;
    refreshUI();
  }

  void toggleObscureConfirmPassword() {
    isObscureConfirmPassword = !isObscureConfirmPassword;
    refreshUI();
  }

  Future<void> register() async {
    isLoading = true;
    refreshUI();

    emailError = _validateEmail(email);
    if (emailError != null) {
      registerError = 'Invalid email: $emailError';
      isLoading = false;
      refreshUI();
      return;
    }

    usernameError = _validateUsername(username);
    if (usernameError != null) {
      registerError = 'Invalid Name: $usernameError';
      isLoading = false;
      refreshUI();
      return;
    }
    passwordError = _validatePassword(password);
    if (passwordError != null) {
      registerError = 'Invalid password: $passwordError';
      isLoading = false;
      refreshUI();
      return;
    }
    confirmPasswordError = _validateConfirmPassword(confirmPassword);
    if (confirmPasswordError != null) {
      registerError = 'Invalid confirm password: $confirmPasswordError';
      isLoading = false;
      refreshUI();
      return;
    }

    // Validate all fields before attempting registration

    // Proceed with registration if validation passes
    try {
      await _userRepository.register(username, password, email);
      ShartflixNavigator.navigateToMainView(getContext());
      // Registration successful - you might want to navigate to login or home screen
    } catch (e) {
      registerError = 'Registration failed: ${e.toString()}';
    }

    isLoading = false;
    refreshUI();
  }

  @override
  void initListeners() {
    // TODO: implement initListeners
  }
}
