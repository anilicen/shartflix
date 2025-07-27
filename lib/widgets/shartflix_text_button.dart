import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shartflix/constants.dart';

class ShartflixTextButton extends StatelessWidget {
  final String text;
  final double borderRadius;
  final Function() onPressed;
  final bool isLoading;
  final double verticalPadding;
  final double horizontalPadding;

  const ShartflixTextButton({
    super.key,
    required this.text,
    this.borderRadius = 18,
    required this.onPressed,
    this.isLoading = false,
    this.verticalPadding = 17,
    this.horizontalPadding = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isLoading ? null : onPressed();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: brandColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: !isLoading
            ? Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: kWhite,
                ),
              ),
      ),
    );
  }
}
