import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class MainController extends Controller {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onTabTapped(int index) {
    _currentIndex = index;
    refreshUI();
  }

  @override
  void initListeners() {
    // Initialize listeners if needed
  }

  @override
  Future<void> onInitState() async {
    super.onInitState();
    // Perform any initial setup here
  }
}
