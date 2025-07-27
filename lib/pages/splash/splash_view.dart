import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/constants.dart';
import 'package:shartflix/data/repositories/user_repository.dart';
import 'package:shartflix/pages/splash/splash_controller.dart';

class SplashView extends View {
  const SplashView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashViewState(
      SplashController(
        DataUserRepository(),
      ),
    );
  }
}

class _SplashViewState extends ViewState<SplashView, SplashController> {
  _SplashViewState(super.controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Euclid',
      ),
      home: Scaffold(
        key: globalKey,
        backgroundColor: backgroundColor,
        body: ControlledWidgetBuilder<SplashController>(
          builder: (context, controller) {
            return SizedBox(
              height: size.height,
              width: size.width,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      backgroundColor,
                      brandColor.withOpacity(0.1),
                      backgroundColor,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App splash image
                    Image.asset(
                      'assets/images/splash_screen.png',
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.cover,
                    ),
                    // Loading indicator
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
