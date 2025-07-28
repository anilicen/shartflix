import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shartflix/constants.dart';
import 'package:shartflix/data/repositories/user_repository.dart';
import 'package:shartflix/pages/login/login_view.dart';
import 'package:shartflix/pages/register/register_controller.dart';
import 'package:shartflix/widgets/shartflix_text_button.dart';
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
          child: ControlledWidgetBuilder<RegisterController>(
            builder: (context, controller) {
              return Container(
                padding: EdgeInsets.only(top: padding.top, left: 45, right: 45),
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
                      onChanged: controller.onUsernameChanged,
                      hintText: 'name_surname'.tr(),
                      icon: 'assets/icons/add.svg',
                    ),
                    const SizedBox(height: 14),
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
                    const SizedBox(height: 14),
                    ShartflixTextField(
                      onChanged: controller.onConfirmPasswordChanged,
                      hintText: 'confirm_password'.tr(),
                      icon: 'assets/icons/unlock.svg',
                      optionalIcon: 'assets/icons/hide.svg',
                      onOptionalIconTap: controller.toggleObscureConfirmPassword,
                      isObscurePassword: controller.isObscureConfirmPassword,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'policy_agreement'.tr(),
                      style: TextStyle(
                        color: kWhite.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ShartflixTextButton(
                      text: "register".tr(),
                      onPressed: controller.register,
                      isLoading: controller.isLoading || controller.isGoogleLoading || controller.isFacebookLoading,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        controller.registerError ?? '',
                        style: const TextStyle(
                          color: brandColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
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
                          'already_have_account'.tr(),
                          style: TextStyle(
                            color: kWhite.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            controller.navigateToLoginView(context);
                          },
                          child: Text(
                            'sign_in'.tr(),
                            style: const TextStyle(
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
