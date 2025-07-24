import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/domain/repositories/user_repository.dart';

class LoginController extends Controller {
  LoginController(UserRepository userRepository) : _userRepository = userRepository;

  final UserRepository _userRepository;
  String email = '';
  String password = '';
  bool isObscurePassword = true;
  void onEmailChanged(String value) {
    email = value;
    refreshUI();
  }

  void onPasswordChanged(String value) {
    password = value;
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
