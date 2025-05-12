import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/backend/authentication/authentication_provider.dart';
import 'package:moviesapp/backend/navigation/navigation_arguments.dart';
import 'package:moviesapp/backend/navigation/navigation_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_operation_parameters.dart';
import 'package:moviesapp/backend/navigation/navigation_type.dart';
import 'package:moviesapp/backend/user/user_controller.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../backend/movies/movies_provider.dart';
import '../../../configs/app_colors.dart';
import '../../../models/movies/response_model/movies_response_model.dart';
import '../../home/components/shimmer_grid_item.dart';

class MoviesTab extends StatelessWidget {
  Function()? onRefresh;
  ScrollController? scrollController;

  MoviesTab({super.key, this.onRefresh, this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Consumer<MoviesProvider>(
      builder: (context, provider, child) {
        if (provider.isFirstTimeLoading.get()) {
          return _buildLoadingGrid();
        }

        if (provider.moviesList.getList().isEmpty) {
          return _buildEmptyState(provider, context);
        }

        return _buildMoviesGrid(provider, context);
      },
    );
  }

  Widget _buildLoadingGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.7,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: 10,
      itemBuilder: (context, index) {
        return SizedBox(
          width: 200.0,
          height: 100.0,
          child: Shimmer.fromColors(
            baseColor: Styles.shimmerBaseColor.withOpacity(.2),
            highlightColor: Styles.shimmerHighlightColor.withOpacity(.4),
            child: ShimmerGridItem()
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(MoviesProvider provider, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (onRefresh != null) onRefresh!();
      },
      color: Styles.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 100),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: const Center(child: Text("No movies found", style: TextStyle(color: Colors.white))),
        ),
      ),
    );
  }

  Widget _buildMoviesGrid(MoviesProvider provider, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (onRefresh != null) onRefresh!();
      },
      color: Styles.primaryColor,
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.7,
        ),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
        itemCount: provider.moviesList.length + (provider.hasMore.get() ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= provider.moviesList.length) {
            return provider.isLoading.get() ? const Center(child: CircularProgressIndicator()) : const SizedBox.shrink();
          }

          return MovieGridItem(movie: provider.moviesList.getList()[index]);
        },
      ),
    );
  }
}

// Keep your existing MovieGridItem and ShimmerGridItem classes
class MovieGridItem extends StatefulWidget {
  final MoviesList movie;
  final bool isFromFavouriteOrWatchList;

  const MovieGridItem({super.key, required this.movie, this.isFromFavouriteOrWatchList = false});

  @override
  State<MovieGridItem> createState() => _MovieGridItemState();
}

class _MovieGridItemState extends State<MovieGridItem> {
  late ValueNotifier<bool> isFavorite;
  late ValueNotifier<bool> isWatchlisted;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthenticationProvider>(context, listen: false).userModel.get();
    isFavorite = ValueNotifier(user?.favorites.contains(widget.movie.id) ?? false);
    isWatchlisted = ValueNotifier(user?.watchlist.contains(widget.movie.id) ?? false);
  }

  void toggleFavorite() async {
    final authenticationProvider = context.read<AuthenticationProvider>();
    final userController = UserController(authenticationProvider: authenticationProvider);
    final movieId = widget.movie.id ?? 0;

    if (isFavorite.value) {
      bool success = await userController.removeFromFavorites(context, movieId);
      if (success) isFavorite.value = false;
    } else {
      bool success = await userController.addToFavorites(context, movieId);
      if (success) isFavorite.value = true;
    }
  }

  void toggleWatchlist() async {
    final authenticationProvider = context.read<AuthenticationProvider>();
    final userController = UserController(authenticationProvider: authenticationProvider);
    final movieId = widget.movie.id ?? 0;

    if (isWatchlisted.value) {
      bool success = await userController.removeFromWatchlist(context, movieId);
      if (success) isWatchlisted.value = false;
    } else {
      bool success = await userController.addToWatchlist(context, movieId);
      if (success) isWatchlisted.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.4)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          NavigationController.navigateToMovieDetailScreen(
            navigationOperationParameters: NavigationOperationParameters(
              context: context,
              navigationType: NavigationType.pushNamed,
            ),
            arguments: MoviesDetailArguments(movieId: movie.id ?? 0),
          );
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: CachedNetworkImage(
                      imageUrl: "https://image.tmdb.org/t/p/w500${movie.posterPath ?? ""}",
                      fit: BoxFit.cover,
                      errorWidget: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.broken_image, color: Colors.black)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  child: Text(
                    movie.title ?? "No title",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(movie.voteAverage?.toStringAsFixed(1) ?? "0.0", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),

            // Favorite toggle
            if(!widget.isFromFavouriteOrWatchList)
            Positioned(
              top: 10,
              left: 10,
              child: ValueListenableBuilder<bool>(
                valueListenable: isFavorite,
                builder: (_, value, __) => GestureDetector(
                  onTap: toggleFavorite,
                  child: _buildGlassIcon(
                    icon: value ? Icons.favorite : Icons.favorite_border,
                    color: value ? Colors.redAccent : Colors.white,
                  ),
                ),
              ),
            ),

            // Watchlist toggle
            if(!widget.isFromFavouriteOrWatchList)
            Positioned(
              top: 10,
              right: 10,
              child: ValueListenableBuilder<bool>(
                valueListenable: isWatchlisted,
                builder: (_, value, __) => GestureDetector(
                  onTap: toggleWatchlist,
                  child: _buildGlassIcon(
                    icon: value ? Icons.bookmark : Icons.bookmark_border,
                    color: value ? Colors.amber : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassIcon({required IconData icon, required Color color}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.35),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}

