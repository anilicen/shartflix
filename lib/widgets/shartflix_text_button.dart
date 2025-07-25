import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shartflix/constants.dart';

class ShartflixTextButton extends StatelessWidget {
  final String text;
  final double height;
  final double borderRadius;
  final Function() onPressed;
  final bool isLoading;

  const ShartflixTextButton({
    super.key,
    required this.text,
    this.height = 54,
    this.borderRadius = 18,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isLoading ? null : onPressed();
      },
      child: Container(
        height: height,
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
