import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shartflix/constants.dart';
import 'package:shartflix/data/repositories/user_repository.dart';
import 'package:shartflix/navigator.dart';
import 'package:shartflix/pages/login/login_controller.dart';
import 'package:shartflix/widgets/shartflix_text_button.dart';
import 'package:shartflix/widgets/shartflix_text_field.dart';
import 'package:flutter/material.dart' hide View;

class LoginView extends View {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _LoginViewState(
      LoginController(
        DataUserRepository(),
      ),
    );
  }
}

class _LoginViewState extends ViewState<LoginView, LoginController> {
  _LoginViewState(super.controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Euclid',
      ),
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            width: size.width,
            child: ControlledWidgetBuilder<LoginController>(
              builder: (context, controller) {
                return Container(
                  padding: EdgeInsets.only(top: padding.top + 20, left: 39, right: 39),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Merhabalar',
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tempus varius a vitae interdum id tortor elementum tristique eleifend at.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ShartflixTextField(
                        onChanged: controller.onEmailChanged,
                        hintText: 'Email',
                        icon: 'assets/icons/message.svg',
                      ),
                      const SizedBox(height: 14),
                      ShartflixTextField(
                        onChanged: controller.onPasswordChanged,
                        hintText: 'Password',
                        icon: 'assets/icons/unlock.svg',
                        optionalIcon: 'assets/icons/hide.svg',
                        onOptionalIconTap: controller.toggleObscurePassword,
                        isObscurePassword: controller.isObscurePassword,
                      ),
                      const SizedBox(height: 30),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            decorationColor: kWhite,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ShartflixTextButton(
                        text: 'Log in',
                        onPressed: controller.login,
                        isLoading: controller.isLoading,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.loginError ?? '',
                          style: const TextStyle(
                            color: brandColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialLogInButton(
                            icon: 'assets/icons/google_logo.svg',
                          ),
                          SizedBox(width: 8),
                          SocialLogInButton(
                            icon: 'assets/icons/apple_logo.svg',
                          ),
                          SizedBox(width: 8),
                          SocialLogInButton(
                            icon: 'assets/icons/facebook_logo.svg',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'You don\'t have an account?',
                            style: TextStyle(
                              color: kWhite.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ShartflixNavigator.navigateToRegisterView(context);
                            },
                            child: const Text(
                              'Sign Up!',
                              style: TextStyle(
                                color: kWhite,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SocialLogInButton extends StatelessWidget {
  final String icon;
  const SocialLogInButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: kWhite.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
          width: 20,
          height: 20,
          color: kWhite,
        ),
      ),
    );
  }
}
