import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/backend/authentication/authentication_provider.dart';
import 'package:moviesapp/backend/movies/movies_provider.dart';
import 'package:moviesapp/models/movies/response_model/movies_detail_response_model.dart';
import 'package:moviesapp/models/movies/response_model/movies_response_model.dart';
import 'package:moviesapp/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../utils/my_print.dart';
import '../authentication/authentication_repository.dart';
import 'movies_repository.dart';

class MoviesController {
  late MoviesProvider _moviesProvider;
  late MoviesRepository _moviesRepository;

  MoviesController({required MoviesProvider? moviesProvider, MoviesRepository? repository}) {
    _moviesProvider = moviesProvider ?? MoviesProvider();
    _moviesRepository = repository ?? MoviesRepository(apiController: ApiController());
  }

  MoviesProvider get moviesProvider => _moviesProvider;

  MoviesRepository get moviesRepository => _moviesRepository;

  Future<void> getMoviesList(BuildContext context, {bool isRefresh = true}) async {
    try {
      final moviesProvider = context.read<MoviesProvider>();

      if (isRefresh) {
        moviesProvider.resetPagination();
      }

      if (!moviesProvider.hasMore.get() || moviesProvider.isLoading.get()) {
        return;
      }

      moviesProvider.isLoading.set(value: true);

      final DataResponseModel<MoviesResponseModel> response = await _moviesRepository.getMovies(moviesProvider.currentPage.get());

      MyPrint.printOnConsole("Data: ${response.data?.toJson() ?? " "}");

      if (response.data == null) {
        // moviesProvider.errorMessage.set('No data received from server');
        return;
      }

      MyPrint.printOnConsole(response.data?.toJson() ?? "");

      if (response.statusCode == 200) {
        final newMovies = response.data?.moviesList ?? [];
        if (isRefresh) {
          _moviesProvider.moviesList.setList(list: newMovies);
        } else {
          _moviesProvider.addMovies(newMovies);
        }

        // Update pagination state
        _moviesProvider.hasMore.set(value: newMovies.length >= _moviesProvider.currentPage.get());
        _moviesProvider.currentPage.set(value: _moviesProvider.currentPage.get() + 1);
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error:" + e.toString());
      MyPrint.printOnConsole(s);
      // moviesProvider.errorMessage.set('An error occurred: ${e.toString()}');
    } finally {
      moviesProvider.isLoading.set(value: false);
      moviesProvider.isFirstTimeLoading.set(value: false);
    }
  }

  Future<void> refreshMoviesList(BuildContext context) async {
    await getMoviesList(context, isRefresh: true);
  }

  Future<void> getMovieDetails(BuildContext context, int movieId) async {
    try {
      moviesProvider.movieDetailLoading.set(value: true);

      final DataResponseModel<MovieDetailsModel> response = await moviesRepository.getMovieDetails(movieId);

      if (response.data == null) {
        moviesProvider.error.set(value: 'Failed to load movie details');
        return;
      }

      MyPrint.printOnConsole("MovieDetailResponse : ${response.data}");

      if (response.statusCode == 200) {
        moviesProvider.movieDetail.set(value: MovieDetailsModel.fromJson(response.data?.toJson() ?? {}));
      } else {
        moviesProvider.error.set(value: response.appErrorModel?.message ?? 'Unknown error occurred');
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in getMovieDetails: $e");
      MyPrint.printOnConsole(s);
      moviesProvider.error.set(value: 'An error occurred while loading movie details');
    } finally {
      moviesProvider.movieDetailLoading.set(value: false);
    }
  }

  Future<void> fetchMovieCredits(int movieId) async {
    moviesProvider.isLoading.set(value: true);

    final response = await moviesRepository.getMovieCredits(movieId);

    if (response.statusCode == 200 && response.data != null) {
      // Assuming you'll add credits to your MoviesProvider
      // You might need to extend MoviesProvider to handle credits
      moviesProvider.setMovieCredits(response.data!.cast);
    } else {
      moviesProvider.error.set(value: response.appErrorModel?.message ?? "Failed to load credits");
    }

    moviesProvider.isLoading.set(value: false);
  }

  Future<void> fetchSimilarMovies(int movieId) async {
    moviesProvider.isSimilarLoading.set(value: true);

    final response = await moviesRepository.getSimilarMovies(movieId);

    if (response.statusCode == 200 && response.data != null) {
      moviesProvider.setSimilarMovies(response.data?.results ?? []);
    } else {
      moviesProvider.error.set(value: response.appErrorModel?.message ?? "Failed to load similar movies");
    }

    moviesProvider.isSimilarLoading.set(value: false);
  }

  // movies_controller.dart (add these to the existing class)
  Future<void> fetchRecommendations(AuthenticationProvider authProvider) async {

    MyPrint.printOnConsole("Fetch recommendation  :");

    try {
      // Get user favorites
      final favorites = authProvider.userModel.get()?.favorites ?? [];
      final name = authProvider.userModel.get()?.displayName ?? [];
      MyPrint.printOnConsole("Fetch recommendation  : $favorites ,$name");


      if (favorites.length < 5) {
        moviesProvider.recommendationError.set(value: true);
        return;
      }

      moviesProvider.recommendationError.set(value: false);

      // Get random 5 favorites
      final randomFavorites = _getRandomElements(favorites, 5);

      List<MoviesList> recommendations = [];

      for (final movieId in randomFavorites) {
        final response = await _moviesRepository.getRecommendations(movieId);

        if (response.statusCode == 200 && response.data != null) {
          MyPrint.printOnConsole("Lengthhhh: ${response.data?.moviesList?.length}");
          for (final movie in response.data?.moviesList ?? []) {
            if (!recommendations.any((m) => m.id == movie.id) && !favorites.contains(movie.id)) {
              recommendations.add(movie);
            }
          }
        }
      }

      moviesProvider.setRecommendations(recommendations);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in fetchRecommendations: $e");
      MyPrint.printOnConsole(s);
      moviesProvider.error.set(value: 'Failed to load recommendations');
    }
  }

  List _getRandomElements<T>(List<T> list, int count) {
    final shuffled = List.from(list)..shuffle();
    return shuffled.take(count).toList();
  }
}
