import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
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

    return Scaffold(
      key: globalKey,
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
                    Text(
                      'hello'.tr(),
                      style: const TextStyle(
                        color: kWhite,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'welcome_message'.tr(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: kWhite,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ShartflixTextField(
                      onChanged: controller.onEmailChanged,
                      hintText: 'email'.tr(),
                      icon: 'assets/icons/message.svg',
                    ),
                    const SizedBox(height: 14),
                    ShartflixTextField(
                      onChanged: controller.onPasswordChanged,
                      hintText: 'password'.tr(),
                      icon: 'assets/icons/unlock.svg',
                      optionalIcon: 'assets/icons/hide.svg',
                      onOptionalIconTap: controller.toggleObscurePassword,
                      isObscurePassword: controller.isObscurePassword,
                    ),
                    const SizedBox(height: 30),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'forgot_password'.tr(),
                        style: const TextStyle(
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
                      text: 'login'.tr(),
                      onPressed: controller.login,
                      isLoading: controller.isLoading || controller.isGoogleLoading || controller.isFacebookLoading,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialLogInButton(
                          icon: 'assets/icons/google_logo.svg',
                          onPressed: controller.signInWithGoogle,
                        ),
                        SizedBox(width: 8),
                        SocialLogInButton(
                          icon: 'assets/icons/apple_logo.svg',
                          onPressed: () {},
                        ),
                        SizedBox(width: 8),
                        SocialLogInButton(
                          icon: 'assets/icons/facebook_logo.svg',
                          onPressed: controller.signInWithFacebook,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'dont_have_account'.tr(),
                          style: TextStyle(
                            color: kWhite.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ShartflixNavigator.navigateToRegisterView(context);
                          },
                          child: Text(
                            'sign_up'.tr(),
                            style: const TextStyle(
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
    );
  }
}

class SocialLogInButton extends StatelessWidget {
  final String icon;
  final Function() onPressed;
  const SocialLogInButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
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
      ),
    );
  }
}
