import 'package:flutter/material.dart' hide View;
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/constants.dart';
import 'package:shartflix/data/repositories/user_repository.dart';
import 'package:shartflix/pages/login/login_view.dart';
import 'package:shartflix/pages/register/register_controller.dart';
import 'package:shartflix/widgets/shartflix_text_field.dart';

class RegisterView extends View {
  @override
  State<StatefulWidget> createState() {
    return _RegisterViewState(
      RegisterController(
        DataUserRepository(),
      ),
    );
  }
}

class _RegisterViewState extends ViewState<RegisterView, RegisterController> {
  _RegisterViewState(RegisterController controller) : super(controller);

  @override
  // TODO: implement view
  Widget get view {
    Size size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: ControlledWidgetBuilder<RegisterController>(
            builder: (context, controller) {
              return Container(
                padding: EdgeInsets.only(top: padding.top + 20, left: 30, right: 30),
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
                      onChanged: controller.onUsernameChanged,
                      hintText: 'Name and Surname',
                      icon: 'assets/icons/add.svg',
                    ),
                    const SizedBox(height: 14),
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
                    ),
                    const SizedBox(height: 14),
                    ShartflixTextField(
                      onChanged: controller.onConfirmPasswordChanged,
                      hintText: 'Confirm Password',
                      icon: 'assets/icons/unlock.svg',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kullanıcı sözleşmesini okudum ve kabul ediyorum. Bu sözelşmeyi okuyarak devam ediniz lütfen.',
                      style: TextStyle(
                        color: kWhite.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 36),
                    const ShartflixTextButton(text: "Register Now"),
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
                          'You have an account?',
                          style: TextStyle(
                            color: kWhite.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to sign up page
                          },
                          child: const Text(
                            'Log In!',
                            style: TextStyle(
                              color: kWhite,
                              fontSize: 12,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
