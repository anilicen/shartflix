import 'dart:async';
import 'package:flutter/material.dart';

/// A singleton service to notify all controllers when language changes
class LanguageNotifier {
  static final LanguageNotifier _instance = LanguageNotifier._internal();
  factory LanguageNotifier() => _instance;
  LanguageNotifier._internal();

  final StreamController<Locale> _languageController = StreamController<Locale>.broadcast();

  /// Stream to listen for language changes
  Stream<Locale> get languageStream => _languageController.stream;

  /// Notify all listeners that language has changed
  void notifyLanguageChanged(Locale locale) {
    _languageController.add(locale);
  }

  /// Dispose the controller when app closes
  void dispose() {
    _languageController.close();
  }
}
