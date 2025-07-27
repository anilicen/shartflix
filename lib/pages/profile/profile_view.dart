import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shartflix/constants.dart';
import 'package:shartflix/data/repositories/movie_repository.dart';
import 'package:shartflix/data/repositories/user_repository.dart';
import 'package:shartflix/pages/profile/profile_controller.dart';
import 'package:flutter/material.dart' hide View;
import 'package:shartflix/widgets/shartflix_text_button.dart';

class ProfileView extends View {
  const ProfileView({super.key});

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return _ProfileViewState(
      ProfileController(
        DataUserRepository(),
        DataMovieRepository(),
      ),
    );
  }
}

class _ProfileViewState extends ViewState<ProfileView, ProfileController> {
  _ProfileViewState(super.controller);

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: ControlledWidgetBuilder<ProfileController>(
          builder: (context, controller) {
            return Container(
              padding: EdgeInsets.only(top: padding.top + 20, left: 26, right: 26),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile Details',
                        style: TextStyle(
                          color: kWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      _LimitedOfferButton(),
                    ],
                  ),
                  SizedBox(height: 42),
                  controller.user == null
                      ? Container()
                      : Row(
                          children: [
                            _ProfilePhotoContainer(photoUrl: controller.user!.photoUrl),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _SlidingText(
                                    text: controller.user!.name,
                                    style: const TextStyle(
                                      color: kWhite,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'ID: ${controller.user!.id.substring(0, 6)}',
                                    style: TextStyle(
                                      color: kWhite.withOpacity(0.5),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            ShartflixTextButton(
                              text: 'Add Photo',
                              borderRadius: 8,
                              verticalPadding: 10,
                              horizontalPadding: 19,
                              onPressed: () {
                                controller.navigateToAddPhotoView(context);
                              },
                            )
                          ],
                        ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: const Text(
                      'Liked Movies',
                      style: TextStyle(
                        color: kWhite,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.6, // Adjust this to control height vs width ratio
                      ),
                      itemCount: controller.favoriteMovies!.length,
                      itemBuilder: (context, index) {
                        final movie = controller.favoriteMovies![index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: CachedNetworkImage(
                                  imageUrl: movie.posterUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              movie.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: kWhite,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              movie.director,
                              style: TextStyle(
                                color: kWhite.withOpacity(0.5),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ProfilePhotoContainer extends StatelessWidget {
  final String photoUrl;
  const _ProfilePhotoContainer({
    super.key,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: photoUrl.isNotEmpty
          ? CachedNetworkImage(
              key: ValueKey(photoUrl), // Add key to force rebuild when URL changes
              imageUrl: photoUrl,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                radius: 60,
                backgroundImage: imageProvider,
              ),
              placeholder: (context, url) => SvgPicture.asset(
                'assets/icons/profile.svg',
                width: 60,
                height: 60,
                color: kWhite,
              ),
              errorWidget: (context, url, error) => const CircleAvatar(
                radius: 60,
                backgroundColor: Colors.red,
              ),
            )
          : SvgPicture.asset(
              'assets/icons/profile.svg',
              width: 60,
              height: 60,
              color: kWhite,
            ),
    );
  }
}

class _LimitedOfferButton extends StatelessWidget {
  const _LimitedOfferButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: brandColor,
        borderRadius: BorderRadius.circular(53),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/gem.svg',
            width: 22,
            height: 22,
          ),
          SizedBox(width: 4),
          Text(
            'Limited Offer',
            style: TextStyle(
              color: kWhite,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

class _SlidingText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _SlidingText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<_SlidingText> createState() => _SlidingTextState();
}

class _SlidingTextState extends State<_SlidingText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late ScrollController _scrollController;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _scrollController = ScrollController();

    // Start automatic scrolling after a delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndStartScrolling();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _checkAndStartScrolling() {
    if (_scrollController.hasClients) {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      if (maxScrollExtent > 0) {
        Future.delayed(const Duration(seconds: 1), () {
          _startScrolling();
        });
      }
    }
  }

  void _startScrolling() {
    if (_scrollController.hasClients && !_isScrolling) {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      if (maxScrollExtent > 0) {
        _isScrolling = true;
        _scrollController
            .animateTo(
          maxScrollExtent,
          duration: Duration(milliseconds: (widget.text.length * 100).clamp(2000, 5000)),
          curve: Curves.linear,
        )
            .then((_) {
          Future.delayed(const Duration(seconds: 1), () {
            if (_scrollController.hasClients) {
              _scrollController
                  .animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              )
                  .then((_) {
                _isScrolling = false;
                // Restart the cycle after a pause
                Future.delayed(const Duration(seconds: 2), () {
                  if (mounted) {
                    _startScrolling();
                  }
                });
              });
            }
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _startScrolling,
      child: SizedBox(
        height: widget.style.fontSize! * 1.2,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Text(
            widget.text,
            style: widget.style,
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
