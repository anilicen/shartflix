import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide View;
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:shartflix/constants.dart';
import 'package:shartflix/data/repositories/movie_repository.dart';
import 'package:shartflix/data/repositories/user_repository.dart';
import 'package:shartflix/pages/discover/discover_controller.dart';

class DiscoverView extends View {
  @override
  State<StatefulWidget> createState() {
    return _DiscoverViewState(
      DiscoverController(
        DataMovieRepository(),
        DataUserRepository(),
      ),
    );
  }
}

class _DiscoverViewState extends ViewState<DiscoverView, DiscoverController> {
  _DiscoverViewState(super.controller);

  @override
  // TODO: implement view
  Widget get view {
    Size size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;

    return MaterialApp(
      home: Scaffold(
        backgroundColor: backgroundColor,
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: ControlledWidgetBuilder<DiscoverController>(
            builder: (context, controller) {
              return Container(
                padding: EdgeInsets.only(top: padding.top + 20, left: 39, right: 39),
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
                        : PageView.builder(
                            itemCount: controller.movies?.length ?? 0,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final movie = controller.movies![index];
                              print(movie.posterUrl);
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  if (controller.token != null)
                                    CachedNetworkImage(
                                      imageUrl: movie.posterUrl,
                                      errorWidget: (context, url, error) {
                                        return const Icon(
                                          Icons.abc,
                                          color: Colors.red,
                                        );
                                      },
                                    )
                                ],
                              );
                            },
                          ),
              );
            },
          ),
        ),
      ),
    );
  }
}
