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

class AuthenticationRepository {
  final ApiController apiController;

  const AuthenticationRepository({required this.apiController});

//   Future<DataResponseModel<LoginResponseModel>> loginWithEmailAndPassword(
//       {required EmailLoginRequestModel login}) async {
//     ApiEndpoints apiEndpoints = apiController.apiEndpoints;
//
//     MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
//
//     ApiCallModel apiCallModel =
//         await apiController.getApiCallModelFromData<String>(
//       restCallType: RestCallType.simplePostCall,
//       parsingType: ModelDataParsingType.loginModel,
//       url: apiEndpoints.apiPostLoginDetails(),
//       requestBody: MyUtils.encodeJson(login.toJson()),
//       isAuthenticatedApiCall: false,
//     );
//
//     DataResponseModel<LoginResponseModel> apiResponseModel =
//         await apiController.callApi<LoginResponseModel>(
//       apiCallModel: apiCallModel,
//     );
//     return apiResponseModel;
//   }
//
//   Future<DataResponseModel<LoginResponseModel>> registerUser(
//       {required RegistrationRequestModel registerUser}) async {
//     ApiEndpoints apiEndpoints = apiController.apiEndpoints;
//
//     MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
//
//     ApiCallModel apiCallModel =
//     await apiController.getApiCallModelFromData<String>(
//       restCallType: RestCallType.simplePostCall,
//       parsingType: ModelDataParsingType.loginModel,
//       url: apiEndpoints.apiRegisterUser(),
//       requestBody: MyUtils.encodeJson(registerUser.toJson()),
//       isAuthenticatedApiCall: false,
//
//     );
//
//     DataResponseModel<LoginResponseModel> apiResponseModel =
//     await apiController.callApi<LoginResponseModel>(
//       apiCallModel: apiCallModel,
//     );
//     return apiResponseModel;
//   }
//
//   Future<DataResponseModel<UserResponseModel>> getUser(String userId) async {
//     ApiEndpoints apiEndpoints = apiController.apiEndpoints;
//
//     MyPrint.printOnConsole("Site Url:${apiController.apiDataProvider.getAuthToken()}");
//
//     ApiCallModel apiCallModel =
//         await apiController.getApiCallModelFromData<String>(
//       restCallType: RestCallType.simpleGetCall,
//       parsingType: ModelDataParsingType.moviesModel,
//       url: apiEndpoints.apiGetUser(userId),
//       isAuthenticatedApiCall: true,
//       token: apiController.apiDataProvider.getAuthToken(),
//     );
//
//     DataResponseModel<UserResponseModel> apiResponseModel =
//         await apiController.callApi<UserResponseModel>(
//       apiCallModel: apiCallModel,
//     );
//
//     return apiResponseModel;
//   }
//
//   Future<DataResponseModel<UserResponseModel>> updateUser(
//       {required UpdateUserModel updateUser}) async {
//     ApiEndpoints apiEndpoints = apiController.apiEndpoints;
//
//     MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
//
//     ApiCallModel apiCallModel =
//     await apiController.getApiCallModelFromData<String>(
//       restCallType: RestCallType.simplePatchCall,
//       parsingType: ModelDataParsingType.moviesModel,
//       url: apiEndpoints.apiUpdateUser(updateUser.id),
//       requestBody: MyUtils.encodeJson(updateUser.toJson()),
//       isAuthenticatedApiCall: true,
//     );
//
//     DataResponseModel<UserResponseModel> apiResponseModel =
//     await apiController.callApi<UserResponseModel>(
//       apiCallModel: apiCallModel,
//     );
//     return apiResponseModel;
//   }
//
//   Future<DataResponseModel<UserResponseModel>> updateUserOnSingleValues(
//       {required Map<String,dynamic> updateMap, required String userId}) async {
//     ApiEndpoints apiEndpoints = apiController.apiEndpoints;
//
//     MyPrint.printOnConsole("Site Url:${apiEndpoints.siteUrl}");
//
//     ApiCallModel apiCallModel =
//     await apiController.getApiCallModelFromData<String>(
//       restCallType: RestCallType.simplePatchCall,
//       parsingType: ModelDataParsingType.moviesModel,
//       url: apiEndpoints.apiUpdateUser(userId),
//       requestBody: MyUtils.encodeJson(updateMap),
//       isAuthenticatedApiCall: true,
//     );
//
//     DataResponseModel<UserResponseModel> apiResponseModel =
//     await apiController.callApi<UserResponseModel>(
//       apiCallModel: apiCallModel,
//     );
//     return apiResponseModel;
//   }
}
