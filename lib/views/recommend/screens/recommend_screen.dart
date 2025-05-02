import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:math';

class RecommendScreen extends StatefulWidget {
  const RecommendScreen({Key? key}) : super(key: key);

  @override
  _RecommendScreenState createState() => _RecommendScreenState();
}

class _RecommendScreenState extends State<RecommendScreen> {
  bool _error = false;
  List<dynamic> _recommendations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // _getRecommendations();
  }

  List<dynamic> _getRandomElements(List<dynamic> arr, int count) {
    final shuffledArray = List.from(arr);
    shuffledArray.shuffle();
    return shuffledArray.take(count).toList();
  }

  Future<Map<String, dynamic>?> _getMovieData(int id) async {
    try {
      final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$id/recommendations?api_key=fc6b0f8734f6d710fed11de93fc496cc',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(json.decode(response.body));
      }
    } catch (error) {
      debugPrint('Error fetching movie data: $error');
    }
    return null;
  }

  // Future<void> _getRecommendations() async {
  //   final userState = Provider.of<UserState>(context, listen: false);
  //   final favorites = userState.favorites;
  //
  //   if (favorites.length < 5) {
  //     setState(() {
  //       _error = true;
  //       _isLoading = false;
  //     });
  //     return;
  //   }
  //
  //   final randomFavorites = _getRandomElements(favorites, 5);
  //   final recommendations = <dynamic>[];
  //
  //   for (final movieId in randomFavorites) {
  //     final movieData = await _getMovieData(movieId);
  //     if (movieData != null && movieData['results'] != null) {
  //       for (final recommendation in movieData['results']) {
  //         if (!recommendations.any((m) => m['id'] == recommendation['id']) &&
  //             !favorites.contains(recommendation['id'])) {
  //           recommendations.add(recommendation);
  //         }
  //       }
  //     }
  //   }
  //
  //   setState(() {
  //     _recommendations = recommendations;
  //     _isLoading = false;
  //     _error = false;
  //   });
  // }

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
                  fontFamily: 'Hero',
                ),
              ),
              const SizedBox(height: 10),
              if (_error)
                Text(
                  '*You should have at least 5 movies in Favorites',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 20,
                    fontFamily: 'Hero',
                  ),
                ),
              if (_isLoading)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (!_error && _recommendations.isNotEmpty)
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.6,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                    ),
                    itemCount: _recommendations.length,
                    itemBuilder: (context, index) {
                      final item = _recommendations[index];
                      if (item['poster_path'] == null) return const SizedBox();

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/movieDetails',
                            arguments: item['id'],
                          );
                        },
                        child: Image.network(
                          'https://image.tmdb.org/t/p/original${item['poster_path']}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.grey),
                        ),
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