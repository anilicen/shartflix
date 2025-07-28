import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/core/language_notifier.dart';

class MainController extends Controller {
  int _currentIndex = 0;
  StreamSubscription? _languageSubscription;

  int get currentIndex => _currentIndex;

  void onTabTapped(int index) {
    _currentIndex = index;
    refreshUI();
  }

  @override
  void initListeners() {
    // Listen for language changes and refresh UI
    _languageSubscription = LanguageNotifier().languageStream.listen((_) {
      refreshUI();
    });
  }

  @override
  void onDisposed() {
    _languageSubscription?.cancel();
    super.onDisposed();
  }

  @override
  Future<void> onInitState() async {
    super.onInitState();
  }
}
