// recommend_screen.dart
import 'package:flutter/material.dart';
import 'package:moviesapp/backend/authentication/authentication_provider.dart';
import 'package:moviesapp/configs/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:moviesapp/backend/movies/movies_controller.dart';
import 'package:moviesapp/backend/movies/movies_provider.dart';

import '../../../backend/navigation/navigation_arguments.dart';
import '../../../backend/navigation/navigation_controller.dart';
import '../../../backend/navigation/navigation_operation_parameters.dart';
import '../../../backend/navigation/navigation_type.dart';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({Key? key}) : super(key: key);

  @override
  _RecommendScreenState createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  late Future<void> _recommendationsFuture;
  late MoviesController controller;
  Future<void> futurGet() async {
    await controller.fetchRecommendations(context.read<AuthenticationProvider>());
  }

  @override
  void initState() {
    super.initState();
    final moviesProvider = context.read<MoviesProvider>();
    controller = MoviesController(moviesProvider: moviesProvider);
    _recommendationsFuture = futurGet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.black.withOpacity(0.2),
        elevation: 0,
        centerTitle: true,
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.auto_awesome, color: Color(0xFFD24DFF), size: 28),
            SizedBox(width: 10),
            Text(
              'Recommended for You',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Expanded(
              child: FutureBuilder(
                future: _recommendationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return Consumer<MoviesProvider>(
                    builder: (context, provider, child) {
                      if (provider.recommendationError.get()) {
                        return Center(
                          child: Text(
                            '*You should have at least 5 movies in Favorites',
                            style: TextStyle(
                              color: Styles.greyColor,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      final recommendations = provider.recommendations.getList();
                      if (recommendations.isEmpty) {
                        return const Center(
                          child: Text(
                            'No recommendations found',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 2 / 3,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          final movie = recommendations[index];
                          if (movie.posterPath == null) return const SizedBox();

                          return GestureDetector(
                            onTap: () {
                              NavigationController.navigateToMovieDetailScreen(
                                navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                                arguments: MoviesDetailArguments(movieId: movie.id ?? 0),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/original${movie.posterPath}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                      child: Icon(Icons.broken_image, color: Colors.white54),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}