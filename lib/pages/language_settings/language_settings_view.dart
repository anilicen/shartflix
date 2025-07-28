import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shartflix/constants.dart';
import 'package:shartflix/pages/language_settings/language_settings_controller.dart';

class LanguageSettingsView extends View {
  const LanguageSettingsView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LanguageSettingsViewState(
      LanguageSettingsController(),
    );
  }
}

class _LanguageSettingsViewState extends ViewState<LanguageSettingsView, LanguageSettingsController> {
  _LanguageSettingsViewState(super.controller);

  @override
  Widget get view {
    return ControlledWidgetBuilder<LanguageSettingsController>(
      builder: (context, controller) {
        return Scaffold(
          key: globalKey,
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: kWhite),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'language_settings'.tr(),
              style: const TextStyle(
                color: kWhite,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: Container(
            padding: const EdgeInsets.only(top: 20, left: 26, right: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'select_language'.tr(),
                  style: const TextStyle(
                    color: kWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                _LanguageOption(
                  title: 'english'.tr(),
                  isSelected: context.locale.languageCode == 'en',
                  onTap: () => controller.changeLanguage(context, const Locale('en', 'US')),
                ),
                const SizedBox(height: 12),
                _LanguageOption(
                  title: 'turkish'.tr(),
                  isSelected: context.locale.languageCode == 'tr',
                  onTap: () => controller.changeLanguage(context, const Locale('tr', 'TR')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? brandColor.withOpacity(0.2) : kWhite.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? brandColor : kWhite.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? brandColor : kWhite,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: brandColor,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
