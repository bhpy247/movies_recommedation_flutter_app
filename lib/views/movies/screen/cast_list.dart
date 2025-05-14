// cast_widget.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/backend/movies/movies_controller.dart';
import 'package:provider/provider.dart';

import '../../../backend/movies/movies_provider.dart';
import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';

class CastWidget extends StatefulWidget {
  final int movieId;

  const CastWidget({Key? key, required this.movieId}) : super(key: key);

  @override
  State<CastWidget> createState() => _CastWidgetState();
}

class _CastWidgetState extends State<CastWidget> {


  @override
  void initState() {
    super.initState();
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    final movieController = MoviesController(moviesProvider: moviesProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      movieController.fetchMovieCredits(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<MoviesProvider>(
      builder: (context, provider, child) {
        if (provider.movieCast.getList().isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.movieCast.getList().length,
            itemBuilder: (context, index) {
              final cast = provider.movieCast.getList()[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to actor profile
                  NavigationController.navigateActorProfileScreen(
                    navigationOperationParameters:
                    NavigationOperationParameters(
                      context: context,
                      navigationType: NavigationType.pushNamed,
                    ),
                    arguments: ActorScreenArguments(actorId: cast.id ?? 0),
                  );
                },
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: 'https://image.tmdb.org/t/p/original${cast.profilePath}',
                          height: 150,
                          width: 100,
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) =>
                              Container(
                                height: 150,
                                width: 100,
                                color: Colors.grey,
                                child: const Icon(Icons.person),
                              ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        cast.name ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        cast.character ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}