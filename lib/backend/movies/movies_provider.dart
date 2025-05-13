import 'package:moviesapp/models/movies/response_model/movies_detail_response_model.dart';
import 'package:moviesapp/models/movies/response_model/movies_response_model.dart';
import 'package:moviesapp/models/movies/response_model/similar_movie_list_model.dart';

import '../../models/movies/response_model/cast_model.dart';
import '../common/common_provider.dart';

class MoviesProvider extends CommonProvider {
  MoviesProvider() {
    hasMore = CommonProviderPrimitiveParameter<bool>(value: true, notify: notify);
    isLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);
    isSimilarLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);
    isFirstTimeLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);
    currentPage = CommonProviderPrimitiveParameter<int>(value: 1, notify: notify);
    moviesList = CommonProviderListParameter(list: [], notify: notify);

    //------------Movie Details Variable-------------
    movieDetailLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);
    error = CommonProviderPrimitiveParameter<String>(value: "", notify: notify);
    movieDetail = CommonProviderPrimitiveParameter<MovieDetailsModel?>(value: null, notify: notify);

    //-------cast and similar movies variables---------

    movieCast = CommonProviderListParameter(list: [], notify: notify);
    similarMovies = CommonProviderListParameter(list: [], notify: notify);
    isSimilarLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);

    // In the constructor:
    recommendations = CommonProviderListParameter(list: [], notify: notify);
    recommendationError = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);

    favouriteMovieList = CommonProviderListParameter(list: [], notify: notify);
    watchList = CommonProviderListParameter(list: [], notify: notify);
    youtubeTrailerId = CommonProviderPrimitiveParameter(value: "", notify: notify);
  }

  late CommonProviderListParameter<MoviesList> moviesList;
  late CommonProviderPrimitiveParameter<bool> hasMore;
  late CommonProviderPrimitiveParameter<bool> isLoading;
  late CommonProviderPrimitiveParameter<bool> isFirstTimeLoading;
  late CommonProviderPrimitiveParameter<int> currentPage;

  //--------Movie Details Variable----------

  late CommonProviderPrimitiveParameter<bool> movieDetailLoading;
  late CommonProviderPrimitiveParameter<String> error;
  late CommonProviderPrimitiveParameter<MovieDetailsModel?> movieDetail;

  //-------cast and similar movies variables---------
  late CommonProviderListParameter<Cast> movieCast;
  late CommonProviderPrimitiveParameter<bool> isSimilarLoading;

  late CommonProviderListParameter<SimilarMovieList> similarMovies;

  late CommonProviderListParameter<MoviesList> recommendations;
  late CommonProviderPrimitiveParameter<bool> recommendationError;

  late CommonProviderListParameter<MovieDetailsModel> favouriteMovieList;
  late CommonProviderListParameter<MovieDetailsModel> watchList;

  late CommonProviderPrimitiveParameter<String> youtubeTrailerId;



  void resetPagination() {
    isFirstTimeLoading = CommonProviderPrimitiveParameter<bool>(value: true, notify: notify);
    isLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);
    currentPage = CommonProviderPrimitiveParameter<int>(value: 1, notify: notify);
    moviesList = CommonProviderListParameter(list: [], notify: notify);
    hasMore = CommonProviderPrimitiveParameter<bool>(value: true, notify: notify);

    //--------Movie Details Variable----------

    movieDetailLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);
    error = CommonProviderPrimitiveParameter<String>(value: "", notify: notify);
    movieDetail = CommonProviderPrimitiveParameter<MovieDetailsModel?>(value: null, notify: notify);

    //-------cast and similar movies variables---------
    movieCast = CommonProviderListParameter(list: [], notify: notify);
    similarMovies = CommonProviderListParameter(list: [], notify: notify);
    isSimilarLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);

    // In resetPagination:
    recommendations = CommonProviderListParameter(list: [], notify: notify);
    recommendationError = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);


    favouriteMovieList = CommonProviderListParameter(list: [], notify: notify);
    watchList = CommonProviderListParameter(list: [], notify: notify);

    youtubeTrailerId = CommonProviderPrimitiveParameter(value: "", notify: notify);

    notifyListeners();
  }

  // Add these methods:
  void setMovieCredits(List<Cast> credits) {
    movieCast.setList(list: credits);
    notifyListeners();
  }

  void setSimilarMovies(List<SimilarMovieList> movies) {
    similarMovies.setList(list: movies);
    notifyListeners();
  }

  void clearSimilarMovies() {
    similarMovies.setList(list: []);
    notifyListeners();
  }

  void addMovies(List<MoviesList> newMovies) {
    List<MoviesList> currentMovieList = moviesList.getList();
    currentMovieList.addAll(newMovies);
    moviesList.setList(list: currentMovieList);
    notifyListeners();
  }

  // Add this method:
  void setRecommendations(List<MoviesList> recommendedMovies) {
    recommendations.setList(list: recommendedMovies);
    notifyListeners();
  }

  void setRecommendationError(bool value) {
    recommendationError.set(value: value);
    notifyListeners();
  }
}
