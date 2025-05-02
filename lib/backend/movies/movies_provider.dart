import 'package:moviesapp/models/movies/response_model/movies_response_model.dart';

import '../common/common_provider.dart';

class MoviesProvider extends CommonProvider {
  MoviesProvider() {
    hasMore = CommonProviderPrimitiveParameter<bool>(value: true, notify: notify);
    isLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);
    isFirstTimeLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);
    currentPage = CommonProviderPrimitiveParameter<int>(value: 1, notify: notify);
    moviesList =  CommonProviderListParameter(list: [], notify: notify);
  }

  late CommonProviderListParameter<MoviesList> moviesList;
  late CommonProviderPrimitiveParameter<bool> hasMore;
  late CommonProviderPrimitiveParameter<bool> isLoading;
  late CommonProviderPrimitiveParameter<bool> isFirstTimeLoading;
  late CommonProviderPrimitiveParameter<int> currentPage;

  void resetPagination() {
    isFirstTimeLoading = CommonProviderPrimitiveParameter<bool>(value: true, notify: notify);
    isLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);
    currentPage = CommonProviderPrimitiveParameter<int>(value: 1, notify: notify);
    moviesList =  CommonProviderListParameter(list: [], notify: notify);
    hasMore = CommonProviderPrimitiveParameter<bool>(value: true, notify: notify);
    notifyListeners();
  }

  void addMovies(List<MoviesList> newMovies) {
    List<MoviesList> currentMovieList = moviesList.getList();
    currentMovieList.addAll(newMovies);
    moviesList.setList(list: currentMovieList);
    notifyListeners();
  }
}
