import 'package:flutter/material.dart';
import 'package:moviesapp/backend/search/search_provider.dart';
import 'package:moviesapp/backend/search/search_repository.dart';
import '../../api/api_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../models/movies/response_model/movies_response_model.dart';

class SearchMovieController {
  late SearchProvider _searchProvider;
  late SearchRepository _searchRepository;


  SearchMovieController({required SearchProvider? searchProvider, SearchRepository? repository}) {
    _searchProvider = searchProvider ?? SearchProvider();
    _searchRepository = repository ?? SearchRepository(apiController: ApiController());
  }

  SearchProvider get searchProvider => _searchProvider;

  SearchRepository get searchRepository => _searchRepository;

  Future<void> searchMovies(String query) async {
    if (query.trim().isEmpty) return;

    searchProvider.setLoading(true);

    try {
      final response = await searchRepository.searchMovies(query);

      if (response.statusCode == 200 && response.data != null) {
        searchProvider.setSearchResults(response.data!.moviesList ?? []);
      } else {
        searchProvider.clearSearchResults();
      }
    } catch (e) {
      debugPrint("Error searching movies: $e");
      searchProvider.clearSearchResults();
    } finally {
      searchProvider.setLoading(false);
    }
  }
}
