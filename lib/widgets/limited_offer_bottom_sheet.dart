import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:flutter_svg/svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shartflix/constants.dart';
import 'package:shartflix/widgets/shartflix_text_button.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  const LimitedOfferBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Bottom radial gradient
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, 1.1), // Bottom-middle position
              radius: 2.2,
              colors: [
                offerBackground, // Bright at bottom-middle
                backgroundColor, // Fades to original color
                backgroundColor, // Stays original color at edges
              ],
              stops: [0.0, 0.4, 1.0],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          height: size.height * 0.8,
        ),
        // Top radial gradient (overlaid)
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0, -1.1), // Top-middle position
              radius: 2.4,
              colors: [
                offerBackground, // Bright at top-middle
                Colors.transparent, // Transparent to show bottom gradient
                Colors.transparent, // Transparent to show bottom gradient
              ],
              stops: [0.0, 0.4, 1.0],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 4,
                offset: Offset(0, -2),
                spreadRadius: 0,
              ),
            ],
          ),
          height: size.height * 0.8, // 70% of screen height
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Handle bar
                Text(
                  'limited_offer'.tr(),
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'limited_offer_description'.tr(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: kWhite.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'bonus_content'.tr(),
                        style: const TextStyle(
                          color: kWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: _LimitedOfferBonus(
                                assetName: 'assets/images/diamond.png',
                                text: 'premium_account'.tr(),
                              ),
                            ),
                            Expanded(
                              child: _LimitedOfferBonus(
                                assetName: 'assets/images/two_hearts.png',
                                text: 'more_matches'.tr(),
                              ),
                            ),
                            Expanded(
                              child: _LimitedOfferBonus(
                                assetName: 'assets/images/promote.png',
                                text: 'promote'.tr(),
                              ),
                            ),
                            Expanded(
                              child: _LimitedOfferBonus(
                                assetName: 'assets/images/heart.png',
                                text: 'more_likes'.tr(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'to_unlock'.tr(),
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: _CoinPackage(
                        lowCoin: '200',
                        highCoin: '300',
                        price: '99.99',
                        baseColor: brandColor,
                        gradientColor: offerBackground,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _CoinPackage(
                        lowCoin: '2000',
                        highCoin: '3375',
                        price: '799.99',
                        baseColor: brandColor,
                        gradientColor: offerGradientColor,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _CoinPackage(
                        lowCoin: '1000',
                        highCoin: '1350',
                        price: '399.99',
                        baseColor: brandColor,
                        gradientColor: offerBackground,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ShartflixTextButton(text: 'see_all_coins'.tr(), onPressed: () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CoinPackage extends StatelessWidget {
  final String lowCoin;
  final String highCoin;
  final String price;
  final Color baseColor;
  final Color gradientColor;
  const _CoinPackage({
    super.key,
    required this.lowCoin,
    required this.highCoin,
    required this.price,
    required this.baseColor,
    required this.gradientColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allow overflow outside the Stack bounds
      children: [
        InnerShadow(
          shadows: const [
            Shadow(
              color: kWhite,
              blurRadius: 7,
              offset: Offset(0, 0),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.only(top: 55, bottom: 11, left: 10, right: 10),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.8, 0.8), // Bottom right position
                radius: 2.1,
                colors: [
                  baseColor, // Base color at bottom left
                  gradientColor, // Gradient color towards bottom right
                ],
                stops: const [0.0, 1.0],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: kWhite.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  lowCoin,
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                Text(
                  highCoin,
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'token'.tr(),
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 35),
                Container(
                  height: 1,
                  color: kWhite.withOpacity(.1),
                ),
                const SizedBox(height: 14),
                Text(
                  '₺$price',
                  style: const TextStyle(
                    color: kWhite,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'weekly'.tr(),
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -12,
          left: 0,
          right: 0,
          child: Center(
            child: InnerShadow(
              shadows: [
                const Shadow(
                  color: kWhite,
                  blurRadius: 4,
                  offset: Offset(0, 0),
                ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: gradientColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Text(
                  '+10%',
                  style: TextStyle(
                    color: kWhite,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LimitedOfferBonus extends StatelessWidget {
  final String assetName;
  final String text;

  const _LimitedOfferBonus({
    super.key,
    required this.assetName,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InnerShadow(
          shadows: [
            const Shadow(
              color: kWhite,
              blurRadius: 7,
              offset: Offset(0, 0),
            ),
          ],
          child: Container(
            height: 60,
            width: 60,
            decoration: const BoxDecoration(
              color: offerBackground,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                assetName,
                height: 30,
                width: 30,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 30, // Fixed height for text area
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: kWhite,
              fontSize: 10,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
