import 'package:moviesapp/models/movies/response_model/movies_response_model.dart';
import 'package:moviesapp/models/user_model/user_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/rest_client.dart';
import '../../models/authentication/login_request_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/user_model/update_user_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class MoviesRepository {
  final ApiController apiController;

  const MoviesRepository({required this.apiController});
  //
  // Future<DataResponseModel<LoginResponseModel>> loginWithEmailAndPassword(
  //     {required EmailLoginRequestModel login}) async {
  //   ApiEndpoints apiEndpoints = apiController.apiEndpoints;
  //
  //   MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
  //
  //   ApiCallModel apiCallModel =
  //   await apiController.getApiCallModelFromData<String>(
  //     restCallType: RestCallType.simplePostCall,
  //     parsingType: ModelDataParsingType.loginModel,
  //     url: apiEndpoints.apiPostLoginDetails(),
  //     requestBody: MyUtils.encodeJson(login.toJson()),
  //     isAuthenticatedApiCall: false,
  //   );
  //
  //   DataResponseModel<LoginResponseModel> apiResponseModel =
  //   await apiController.callApi<LoginResponseModel>(
  //     apiCallModel: apiCallModel,
  //   );
  //   return apiResponseModel;
  // }
  //
  // Future<DataResponseModel<LoginResponseModel>> registerUser(
  //     {required RegistrationRequestModel registerUser}) async {
  //   ApiEndpoints apiEndpoints = apiController.apiEndpoints;
  //
  //   MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
  //
  //   ApiCallModel apiCallModel =
  //   await apiController.getApiCallModelFromData<String>(
  //     restCallType: RestCallType.simplePostCall,
  //     parsingType: ModelDataParsingType.loginModel,
  //     url: apiEndpoints.apiRegisterUser(),
  //     requestBody: MyUtils.encodeJson(registerUser.toJson()),
  //     isAuthenticatedApiCall: false,
  //
  //   );
  //
  //   DataResponseModel<LoginResponseModel> apiResponseModel =
  //   await apiController.callApi<LoginResponseModel>(
  //     apiCallModel: apiCallModel,
  //   );
  //   return apiResponseModel;
  // }

  Future<DataResponseModel<MoviesResponseModel>> getMovies(int page) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiController.apiDataProvider.getAuthToken()}");

    ApiCallModel apiCallModel =
    await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.moviesModel,
      url: apiEndpoints.apiGetMovies(page),
      // isAuthenticatedApiCall: true,
      // token: apiController.apiDataProvider.getAuthToken(),
    );

    DataResponseModel<MoviesResponseModel> apiResponseModel =
    await apiController.callApi<MoviesResponseModel>(
      apiCallModel: apiCallModel,
    );

    return apiResponseModel;
  }
}
