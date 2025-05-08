import 'package:flutter/material.dart';
import 'package:moviesapp/backend/movies/movies_controller.dart';
import 'package:provider/provider.dart';

import '../../../backend/authentication/authentication_controller.dart';
import '../../../backend/movies/movies_provider.dart';
import '../../../models/movies/response_model/movies_detail_response_model.dart';
import '../../../models/movies/response_model/movies_response_model.dart';
import '../../../configs/app_colors.dart';
import '../../movies/screen/movies_screen.dart';

class FavoritesAndWatchlistScreen extends StatefulWidget {
  const FavoritesAndWatchlistScreen({super.key});

  @override
  State<FavoritesAndWatchlistScreen> createState() => _FavoritesAndWatchlistScreenState();
}

class _FavoritesAndWatchlistScreenState extends State<FavoritesAndWatchlistScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<void> _loadMoviesFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadMoviesFuture = _loadMovies(context);
  }

  Future<void> _loadMovies(BuildContext context) async {
    final movieController = MoviesController(moviesProvider: context.read());
    await Future.wait([movieController.getFavoriteMoviesList(context), movieController.getWatchlistMoviesList(context)]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black.withOpacity(0.2),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () async {
                await AuthenticationController(
                  authenticationProvider: context.read(),
                ).logout(isShowConfirmationDialog: true, isNavigateToLogin: true);
              },
              icon: Icon(Icons.logout),
            ),
          ],
          centerTitle: true,
          title: const Text("My Stuff", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: Colors.white)),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Styles.primaryColor,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: UnderlineTabIndicator(borderSide: BorderSide(color: Styles.primaryColor)),
            dividerColor: Colors.white.withValues(alpha: .5),
            labelColor: Styles.primaryColor,
            labelStyle: TextStyle(color: Styles.primaryColor, fontSize: 20),
            tabs: const [Tab(text: "Favorites"), Tab(text: "Watchlist")],
          ),
        ),
        body: FutureBuilder<void>(
          future: _loadMoviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: Styles.primaryColor));
            }
            if (snapshot.hasError) {
              return const Center(child: Text("Failed to load movies", style: TextStyle(color: Colors.white)));
            }

            final moviesProvider = context.watch<MoviesProvider>();
            final List<MovieDetailsModel> favoriteMovies = moviesProvider.favouriteMovieList.getList() ?? [];
            final List<MovieDetailsModel> watchlistMovies = moviesProvider.watchList.getList() ?? [];

            return TabBarView(
              controller: _tabController,
              children: [_buildMoviesGridFromDetails(favoriteMovies), _buildMoviesGridFromDetails(watchlistMovies)],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMoviesGridFromDetails(List<MovieDetailsModel> movies) {
    if (movies.isEmpty) {
      return const Center(child: Text("No movies found", style: TextStyle(color: Colors.white)));
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.7,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MovieGridItem(
          isFromFavouriteOrWatchList: true,
          movie: MoviesList(id: movie.id, title: movie.title, voteAverage: movie.voteAverage, posterPath: movie.posterPath),
        );
      },
    );
  }
}
