// cast_widget.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/backend/movies/movies_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_arguments.dart';
import 'package:moviesapp/backend/navigation/navigation_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_operation_parameters.dart';
import 'package:moviesapp/backend/navigation/navigation_type.dart';
import 'package:provider/provider.dart';

import '../../../backend/movies/movies_provider.dart';

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
                  width: 110,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.04),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: CachedNetworkImage(
                          imageUrl:
                              'https://image.tmdb.org/t/p/w500${cast.profilePath}',
                          height: 140,
                          width: 110,
                          fit: BoxFit.cover,
                          errorWidget: (context, error, stackTrace) => Container(
                            height: 140,
                            width: 110,
                            color: Colors.grey[800],
                            child: const Icon(Icons.person, size: 32, color: Colors.white54),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        child: Column(
                          children: [
                            Text(
                              cast.name ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              cast.character ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
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
