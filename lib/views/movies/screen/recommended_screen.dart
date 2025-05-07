// recommend_screen.dart
import 'package:flutter/material.dart';
import 'package:moviesapp/backend/authentication/authentication_provider.dart';
import 'package:moviesapp/configs/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:moviesapp/backend/movies/movies_controller.dart';
import 'package:moviesapp/backend/movies/movies_provider.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MOVIES YOU MIGHT LIKE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
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
                                Navigator.pushNamed(
                                  context,
                                  '/movieDetails',
                                  arguments: movie.id,
                                );
                              },
                              child: Image.network(
                                'https://image.tmdb.org/t/p/original${movie.posterPath}',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.error,
                                      color: Colors.red,
                                    ),
                                  );
                                },
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
      ),
    );
  }
}