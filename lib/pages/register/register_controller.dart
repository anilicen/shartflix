import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/domain/repositories/user_repository.dart';

class RegisterController extends Controller {
  RegisterController(UserRepository userRepository) : _userRepository = userRepository;
  final UserRepository _userRepository;
  String email = '';
  String password = '';
  String confirmPassword = '';
  String username = '';
  bool isObscurePassword = true;

  void onEmailChanged(String value) {
    email = value;
    refreshUI();
  }

  void onPasswordChanged(String value) {
    password = value;
    refreshUI();
  }

  void onConfirmPasswordChanged(String value) {
    confirmPassword = value;
    refreshUI();
  }

  void onUsernameChanged(String value) {
    username = value;
    refreshUI();
  }

  void toggleObscurePassword() {
    isObscurePassword = !isObscurePassword;
    refreshUI();
  }

  @override
  void initListeners() {
    // TODO: implement initListeners
  }
}
