import '../common/common_provider.dart';
import '../../models/movies/response_model/movies_response_model.dart';

class SearchProvider extends CommonProvider {
  SearchProvider() {
    isLoading = CommonProviderPrimitiveParameter<bool>(value: false, notify: notify);
    searchResults = CommonProviderListParameter<MoviesList>(list: [], notify: notify);
  }

  late CommonProviderPrimitiveParameter<bool> isLoading;
  late CommonProviderListParameter<MoviesList> searchResults;

  void setSearchResults(List<MoviesList> results) {
    searchResults.setList(list: results);
    notifyListeners();
  }

  void clearSearchResults() {
    searchResults.setList(list: []);
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading.set(value: value);
    notifyListeners();
  }
}
