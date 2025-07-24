import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shartflix/constants.dart';

class ShartflixTextField extends StatelessWidget {
  final Function(String) onChanged;
  final String hintText;
  final String icon;
  final String? optionalIcon;
  final Function()? onOptionalIconTap;
  final bool isObscurePassword;

  const ShartflixTextField({
    super.key,
    required this.onChanged,
    required this.hintText,
    required this.icon,
    this.optionalIcon,
    this.onOptionalIconTap,
    this.isObscurePassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kWhite.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: kWhite.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              width: 20,
              height: 20,
              color: kWhite,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                onChanged: onChanged,
                obscureText: isObscurePassword,
                style: const TextStyle(
                  color: kWhite,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: kWhite.withOpacity(0.5),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            if (optionalIcon != null)
              GestureDetector(
                onTap: () {
                  onOptionalIconTap?.call();
                },
                child: Container(
                  height: 40,
                  width: 32,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      optionalIcon!,
                      width: 20,
                      height: 20,
                      color: kWhite,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
