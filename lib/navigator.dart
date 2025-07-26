import 'package:flutter/cupertino.dart';
import 'package:shartflix/pages/add_photo/add_photo_view.dart';
import 'package:shartflix/pages/login/login_view.dart';
import 'package:shartflix/pages/main/main_view.dart';
import 'package:shartflix/pages/register/register_view.dart';

class ShartflixNavigator {
  static Future<void> navigateToLoginView(BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => const LoginView(),
      ),
    );
  }

  static Future<void> navigateToRegisterView(BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => RegisterView(),
      ),
    );
  }

  static Future<void> navigateToMainView(BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => const MainView(),
      ),
    );
  }

  static Future<void> navigateToAddPhotoView(BuildContext context) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => const AddPhotoView(),
      ),
    );
  }
}
