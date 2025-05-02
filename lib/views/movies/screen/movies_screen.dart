// Tab Widgets - Replace these with your actual content

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      itemBuilder: (context, index) => const ShimmerGridItem(),
    );
  }

  Widget _buildEmptyState(MoviesProvider provider, BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async{
        if(onRefresh!() != null){
          onRefresh!();
        }
      },
      color: Styles.primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("No movies found"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesGrid(MoviesProvider provider, BuildContext context) {

    return RefreshIndicator(
      onRefresh: ()async{
        if(onRefresh!() != null){
          onRefresh!();
        }
      },
      color: Styles.primaryColor,
      child: GridView.builder(
        // controller: homeState._scrollController,
        controller: scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        padding: const EdgeInsets.all(10),
        itemCount: provider.moviesList.length + (provider.hasMore.get() ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= provider.moviesList.length) {
            return provider.isLoading.get()
                ? const Center(child: CircularProgressIndicator())
                : const SizedBox.shrink();
          }

          return MovieGridItem(movie: provider.moviesList.getList()[index]);
        },
      ),
    );
  }
}


// Keep your existing MovieGridItem and ShimmerGridItem classes
class MovieGridItem extends StatelessWidget {
  final MoviesList movie;

  const MovieGridItem({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.network(
              "https://image.tmdb.org/t/p/w500${movie.posterPath ?? ""}",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movie.title ?? "No title",
              style: Theme.of(context).textTheme.titleSmall,
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
                Text(
                  movie.voteAverage?.toStringAsFixed(1) ?? "0.0",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

