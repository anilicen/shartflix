import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide View;
import 'package:flutter/gestures.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shartflix/constants.dart';
import 'package:shartflix/core/helpers/fast_page_scroll_physics.dart';
import 'package:shartflix/data/repositories/movie_repository.dart';
import 'package:shartflix/pages/discover/discover_controller.dart';

class DiscoverView extends View {
  static VoidCallback? _animateToFirstPageCallback;

  const DiscoverView({super.key});

  static void animateToFirstPage() {
    _animateToFirstPageCallback?.call();
  }

  @override
  State<StatefulWidget> createState() {
    return _DiscoverViewState(
      DiscoverController(
        DataMovieRepository(),
      ),
    );
  }
}

class _DiscoverViewState extends ViewState<DiscoverView, DiscoverController> with SingleTickerProviderStateMixin {
  _DiscoverViewState(super.controller);

  PageController? _pageController;

  void animateToFirstPage() {
    _pageController?.animateToPage(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  Widget get view {
    Size size = MediaQuery.of(context).size;

    DiscoverView._animateToFirstPageCallback = animateToFirstPage;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: ControlledWidgetBuilder<DiscoverController>(
            builder: (context, controller) {
              return Container(
                child: controller.movies == null
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: kWhite,
                        ),
                      )
                    : controller.movies!.isEmpty
                        ? const Center(
                            child: Text(
                              'No movies found',
                              style: TextStyle(color: kWhite, fontSize: 16),
                            ),
                          )
                        : Stack(
                            children: [
                              PageView.builder(
                                controller: _pageController ??= PageController(
                                  initialPage: controller.savedIndex ?? 0,
                                ),
                                itemCount: controller.movies?.length ?? 0,
                                scrollDirection: Axis.vertical,
                                pageSnapping: true,
                                physics: const FastPageScrollPhysics(parent: PageScrollPhysics()),
                                itemBuilder: (context, index) {
                                  controller.saveIndex(index); //saving index for later use in data repository
                                  controller.getMovies(index); // getMovies every time index is %5 = 0,

                                  final movie = controller.movies![index];
                                  return Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: movie.posterUrl,
                                        width: size.width,
                                        height: size.height,
                                        fit: BoxFit.cover,
                                        fadeInDuration: Duration.zero,
                                        placeholderFadeInDuration: Duration.zero,
                                        progressIndicatorBuilder: (context, url, downloadProgress) {
                                          // Only show loading indicator if there's actual download progress
                                          if (downloadProgress.progress == null) {
                                            return Container(
                                              width: size.width,
                                              height: size.height,
                                              color: backgroundColor,
                                            );
                                          }
                                          return Container(
                                            width: size.width,
                                            height: size.height,
                                            color: backgroundColor,
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: kWhite,
                                                value: downloadProgress.progress,
                                              ),
                                            ),
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          return Container(
                                            width: size.width,
                                            height: size.height,
                                            color: backgroundColor,
                                            child: const Center(
                                              child: Icon(
                                                Icons.movie_outlined,
                                                color: Colors.red,
                                                size: 64,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 70,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(.5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 35,
                                        left: 35,
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                color: brandColor,
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: kWhite,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: Center(
                                                child: SvgPicture.asset('assets/icons/author.svg'),
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  movie.title,
                                                  style: const TextStyle(
                                                    color: kWhite,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                SizedBox(
                                                  width: size.width - 120, // Account for circle + padding
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      if (controller.isDescriptionExpanded(index))
                                                        Text(
                                                          movie.description,
                                                          style: const TextStyle(
                                                            color: kWhite,
                                                            fontSize: 13,
                                                          ),
                                                        )
                                                      else
                                                        RichText(
                                                          text: TextSpan(
                                                            children: [
                                                              TextSpan(
                                                                text: controller.getTruncatedText(
                                                                    movie.description, size.width - 120),
                                                                style: TextStyle(
                                                                  color: kWhite.withOpacity(0.75),
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                              if (controller.needsShowMore(
                                                                  movie.description, size.width - 120))
                                                                TextSpan(
                                                                  text: " Show more",
                                                                  style: const TextStyle(
                                                                    color: kWhite,
                                                                    fontSize: 13,
                                                                    fontWeight: FontWeight.w700,
                                                                  ),
                                                                  recognizer: TapGestureRecognizer()
                                                                    ..onTap = () {
                                                                      controller.toggleDescriptionExpansion(index);
                                                                    },
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                      if (controller.isDescriptionExpanded(index))
                                                        GestureDetector(
                                                          onTap: () {
                                                            controller.toggleDescriptionExpansion(index);
                                                          },
                                                          child: const Text(
                                                            "Show less",
                                                            style: TextStyle(
                                                              color: Colors.grey,
                                                              fontSize: 13,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 100,
                                        right: 16,
                                        child: GestureDetector(
                                          onTap: () async {
                                            controller.initializeLikeAnimation(this);
                                            controller.triggerLikeAnimation();
                                            await controller.toggleMovieLike(index);
                                          },
                                          child: AnimatedBuilder(
                                            animation: controller.likeAnimation ?? const AlwaysStoppedAnimation(1.0),
                                            builder: (context, child) {
                                              return Transform.scale(
                                                scale: controller.likeAnimation?.value ?? 1.0,
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                                                  decoration: BoxDecoration(
                                                    color: kBlack.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(82),
                                                    border: Border.all(
                                                      color: kWhite.withOpacity(0.2),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/icons/heart.svg',
                                                    width: 24,
                                                    height: 24,
                                                    color: controller.isMovieLiked(index) ? Colors.red : kWhite,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
              );
            },
          ),
        ),
      ),
    );
  }
}
