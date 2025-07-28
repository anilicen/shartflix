import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shartflix/domain/repositories/user_repository.dart';
import 'package:shartflix/navigator.dart';

class LoginController extends Controller {
  LoginController(UserRepository userRepository) : _userRepository = userRepository;

  final UserRepository _userRepository;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  String email = '';
  String password = '';
  bool isObscurePassword = true;

  String? emailError;
  String? loginError;

  bool isLoading = false;
  bool isGoogleLoading = false;
  bool isFacebookLoading = false;

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
    loginError = null; // Reset login error on password change
    refreshUI();
  }

  void toggleObscurePassword() {
    isObscurePassword = !isObscurePassword;
    refreshUI();
  }

  Future<void> signInWithGoogle() async {
    isGoogleLoading = true;
    refreshUI();

    try {
      // Sign out first to ensure fresh account selection
      await _googleSignIn.signOut();

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
      // Sign out on error to allow fresh account selection next time
      await _googleSignIn.signOut();
      loginError = '${'google_signin_failed'.tr()}: ${e.toString()}';
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
      loginError = '${'facebook_signin_failed'.tr()}: ${e.toString()}';
      print('Facebook Sign-In error: ${e.toString()}');
    }

    isFacebookLoading = false;
    refreshUI();
  }

  Future<void> login() async {
    isLoading = true;
    refreshUI();

    emailError = _validateEmail(email);

    // Validate email before attempting login
    if (!isEmailValid) {
      // Handle invalid email - you might want to show an error message
      loginError = '${'invalid_email'.tr()}: $emailError';
      isLoading = false;
      refreshUI();
      return;
    }

    if (password.isEmpty) {
      loginError = 'password_required'.tr();
      isLoading = false;
      refreshUI();
      return;
    }

    // Proceed with login if validation passes
    try {
      await _userRepository.login(email, password);
      ShartflixNavigator.navigateToMainView(getContext());
    } catch (e) {
      loginError = '${'login_failed'.tr()}: ${e.toString()}';
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
