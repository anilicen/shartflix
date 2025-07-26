import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shartflix/constants.dart';
import 'package:shartflix/pages/add_photo/add_photo_view.dart';
import 'package:shartflix/pages/discover/discover_view.dart';
import 'package:shartflix/pages/main/main_controller.dart';

class MainView extends View {
  const MainView({super.key});

  @override
  State<MainView> createState() {
    return _MainViewState(
      MainController(),
    );
  }
}

class _MainViewState extends ViewState<MainView, MainController> {
  _MainViewState(super.controller);

  final List<Widget> _screens = [
    DiscoverView(),
    const AddPhotoView(),
  ];

  @override
  Widget get view {
    return ControlledWidgetBuilder<MainController>(
      builder: (context, controller) {
        return Scaffold(
          body: _screens[controller.currentIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[800]!,
                  width: 0.5,
                ),
              ),
            ),
            child: SafeArea(
              child: Container(
                height: 72,
                padding: const EdgeInsets.only(top: 10, bottom: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Discover Tab
                    _buildCustomNavItem(
                      controller: controller,
                      index: 0,
                      assetName: 'assets/icons/home.svg',
                      label: 'Discover',
                    ),
                    const SizedBox(width: 16),
                    // Profile Tab
                    _buildCustomNavItem(
                      controller: controller,
                      index: 1,
                      assetName: 'assets/icons/profile.svg',
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomNavItem({
    required MainController controller,
    required int index,
    required String assetName,
    required String label,
  }) {
    final bool isActive = controller.currentIndex == index;

    return GestureDetector(
      onTap: () {
        controller.onTabTapped(index);
        if (index == 0 && controller.currentIndex == 0) {
          DiscoverView.animateToFirstPage();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? brandColor : kWhite.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              assetName,
              color: kWhite,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: kWhite,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for Profile Screen
