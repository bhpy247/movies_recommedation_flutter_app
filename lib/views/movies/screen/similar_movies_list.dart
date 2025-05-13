// similar_movies_widget.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/backend/movies/movies_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_arguments.dart';
import 'package:moviesapp/backend/navigation/navigation_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_operation_parameters.dart';
import 'package:moviesapp/backend/navigation/navigation_type.dart';
import 'package:provider/provider.dart';

import '../../../backend/movies/movies_provider.dart';

class SimilarMoviesWidget extends StatefulWidget {
  final int movieId;

  const SimilarMoviesWidget({Key? key, required this.movieId})
    : super(key: key);

  @override
  State<SimilarMoviesWidget> createState() => _SimilarMoviesWidgetState();
}

class _SimilarMoviesWidgetState extends State<SimilarMoviesWidget> {
  @override
  void initState() {
    super.initState();
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    final movieController = MoviesController(moviesProvider: moviesProvider);

    // Fetch similar movies when widget is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      movieController.fetchSimilarMovies(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesProvider>(
      builder: (context, provider, child) {
        if (provider.similarMovies.getList().isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: provider.similarMovies.getList().length,
            itemBuilder: (context, index) {
              final movie = provider.similarMovies.getList()[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to movie details
                  NavigationController.navigateToMovieDetailScreen(
                    navigationOperationParameters:
                        NavigationOperationParameters(
                          context: context,
                          navigationType: NavigationType.pushNamed,
                        ),
                    arguments: MoviesDetailArguments(movieId: movie.id ?? 0),
                  );
                },
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://image.tmdb.org/t/p/original${movie.posterPath}',
                      height: 200,
                      width: 130,
                      fit: BoxFit.cover,
                      errorWidget:
                          (context, error, stackTrace) => Container(
                            height: 200,
                            width: 130,
                            color: Colors.grey,
                            child: const Icon(Icons.movie),
                          ),
                    ),
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
