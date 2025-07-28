import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  bool isLoading = false;
  bool isGoogleLoading = false;
  bool isFacebookLoading = false;

  // Email regex pattern
  static const String _emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static final RegExp _emailRegex = RegExp(_emailPattern);
  Future<void> signInWithGoogle() async {
    isGoogleLoading = true;
    refreshUI();

    try {
      // Trigger the authentication flow
      print('Starting Google Sign-In...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled the sign-in
        isGoogleLoading = false;
        refreshUI();
        return;
      }
      print('Google User: ${googleUser.email}, ${googleUser.displayName}');
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Use the Google user data to sign in with your backend
      await _userRepository.signInWithGoogle(
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
        email: googleUser.email,
        displayName: googleUser.displayName ?? '',
        photoUrl: googleUser.photoUrl ?? '',
      );
      print('Google Sign-In successful: ${googleUser.email}');

      // Navigate to main view on successful login
      ShartflixNavigator.navigateToMainView(getContext());
    } catch (e) {
      registerError = '${'google_signin_failed'.tr()}: ${e.toString()}';
    }

    isGoogleLoading = false;
    refreshUI();
  }

  Future<void> signInWithFacebook() async {
    isFacebookLoading = true;
    refreshUI();

    try {
      // Trigger the authentication flow
      print('Starting Facebook Sign-In...');
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.success) {
        // Get user data
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)",
        );

        print('Facebook User: ${userData['email']}, ${userData['name']}');

        // Use the Facebook user data to sign in with your backend
        await _userRepository.signInWithFacebook(
          accessToken: result.accessToken!.token,
          email: userData['email'] ?? '',
          displayName: userData['name'] ?? '',
          photoUrl: userData['picture']?['data']?['url'] ?? '',
        );

        print('Facebook Sign-In successful: ${userData['email']}');

        // Navigate to main view on successful login
        ShartflixNavigator.navigateToMainView(getContext());
      } else if (result.status == LoginStatus.cancelled) {
        // User cancelled the sign-in
        print('Facebook Sign-In cancelled by user');
      } else {
        throw Exception('Facebook Sign-In failed: ${result.message}');
      }
    } catch (e) {
      registerError = '${'facebook_signin_failed'.tr()}: ${e.toString()}';
      print('Facebook Sign-In error: ${e.toString()}');
    }

    isFacebookLoading = false;
    refreshUI();
  }

  void onEmailChanged(String value) {
    email = value;
    registerError = null; // Reset register error on email change
    refreshUI();
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return 'email_required'.tr();
    }
    if (!_emailRegex.hasMatch(email)) {
      return 'email_invalid'.tr();
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
      return 'password_required'.tr();
    }
    if (password.length < 6) {
      return 'password_min_length'.tr();
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
      return 'confirm_password_required'.tr();
    }
    if (confirmPassword != password) {
      return 'passwords_not_match'.tr();
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
      return 'name_required'.tr();
    }
    if (username.length < 3) {
      return 'name_min_length'.tr();
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
      registerError = '${'invalid_email'.tr()}: $emailError';
      isLoading = false;
      refreshUI();
      return;
    }

    usernameError = _validateUsername(username);
    if (usernameError != null) {
      registerError = '${'invalid_name'.tr()}: $usernameError';
      isLoading = false;
      refreshUI();
      return;
    }
    passwordError = _validatePassword(password);
    if (passwordError != null) {
      registerError = '${'invalid_password'.tr()}: $passwordError';
      isLoading = false;
      refreshUI();
      return;
    }
    confirmPasswordError = _validateConfirmPassword(confirmPassword);
    if (confirmPasswordError != null) {
      registerError = '${'invalid_confirm_password'.tr()}: $confirmPasswordError';
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
      registerError = '${'registration_failed'.tr()}: ${e.toString()}';
    }

    isLoading = false;
    refreshUI();
  }

  @override
  void initListeners() {
    // TODO: implement initListeners
  }
}
