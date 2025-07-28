import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shartflix/core/language_notifier.dart';

class LanguageSettingsController extends Controller {
  void changeLanguage(BuildContext context, Locale locale) {
    context.setLocale(locale);

    // Notify all controllers about language change
    LanguageNotifier().notifyLanguageChanged(locale);

    refreshUI();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'language_changed_successfully'.tr(),
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void initListeners() {
    // No listeners needed for this simple controller
  }
}
