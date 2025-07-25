import 'package:flutter/cupertino.dart';
import 'package:shartflix/pages/discover/discover_view.dart';
import 'package:shartflix/pages/login/login_view.dart';
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

  static Future<void> navigateToDiscoverView(BuildContext context) async {
    await Navigator.pushReplacement(
      context,
      CupertinoPageRoute(
        builder: (context) => DiscoverView(),
      ),
    );
  }
}
