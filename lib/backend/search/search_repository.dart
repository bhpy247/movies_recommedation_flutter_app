import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/rest_client.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/movies/response_model/movies_response_model.dart';

class SearchRepository {
  final ApiController apiController;

  const SearchRepository({required this.apiController});

  Future<DataResponseModel<MoviesResponseModel>> searchMovies(String query) async {
    final apiEndpoints = apiController.apiEndpoints;

    final apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.moviesModel,
      url: apiEndpoints.apiSearchMovies(query),
    );

    final apiResponse = await apiController.callApi<MoviesResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponse;
  }
}
