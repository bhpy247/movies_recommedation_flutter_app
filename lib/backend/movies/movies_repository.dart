import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moviesapp/configs/constants.dart';
import 'package:moviesapp/configs/typedefs.dart';
import 'package:moviesapp/models/movies/response_model/movie_videos_response.dart';
import 'package:moviesapp/models/movies/response_model/movies_response_model.dart';
import 'package:moviesapp/models/movies/response_model/similar_movie_list_model.dart';
import 'package:moviesapp/models/movies/response_model/similar_movie_list_model.dart';
import 'package:moviesapp/models/user_model/user_model.dart';

import '../../api/api_call_model.dart';
import '../../api/api_controller.dart';
import '../../api/api_endpoints.dart';
import '../../api/rest_client.dart';
import '../../models/authentication/login_request_model.dart';
import '../../models/common/data_response_model.dart';
import '../../models/common/model_data_parser.dart';
import '../../models/movies/response_model/actor_detail_model.dart';
import '../../models/movies/response_model/cast_model.dart';
import '../../models/movies/response_model/movies_detail_response_model.dart';
import '../../models/user_model/update_user_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class MoviesRepository {
  final ApiController apiController;

  const MoviesRepository({required this.apiController});

  Future<DataResponseModel<MoviesResponseModel>> getMovies(int page) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    MyPrint.printOnConsole("Site Url:${apiController.apiDataProvider.getAuthToken()}");

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.moviesModel,
      url: apiEndpoints.apiGetMovies(page),
      // isAuthenticatedApiCall: true,
      // token: apiController.apiDataProvider.getAuthToken(),
    );

    DataResponseModel<MoviesResponseModel> apiResponseModel = await apiController.callApi<MoviesResponseModel>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  Future<DataResponseModel<MovieDetailsModel>> getMovieDetails(int movieId) async {
    ApiEndpoints apiEndpoints = apiController.apiEndpoints;

    ApiCallModel apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.moviesDetailResponseModel,
      url: apiEndpoints.apiGetMovieDetails(movieId),
    );

    DataResponseModel<MovieDetailsModel> apiResponseModel = await apiController.callApi<MovieDetailsModel>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  Future<DataResponseModel<CastResponseModel>> getMovieCredits(int movieId) async {
    final apiEndpoints = apiController.apiEndpoints;

    final apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.castListModel,
      url: apiEndpoints.apiGetMovieCredits(movieId),
    );

    final apiResponseModel = await apiController.callApi<CastResponseModel>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  Future<DataResponseModel<SimilarMoviesResponseModel>> getSimilarMovies(int movieId) async {
    final apiEndpoints = apiController.apiEndpoints;

    final apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.similarMoviesModel,
      url: apiEndpoints.apiGetSimilarMovies(movieId),
    );

    final apiResponseModel = await apiController.callApi<SimilarMoviesResponseModel>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  // movies_repository.dart (add this to the existing class)
  Future<DataResponseModel<MoviesResponseModel>> getRecommendations(int movieId) async {
    final apiEndpoints = apiController.apiEndpoints;

    final apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.moviesModel,
      url: apiEndpoints.apiGetRecommendations(movieId),
    );

    final apiResponseModel = await apiController.callApi<MoviesResponseModel>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }

  Future<DataResponseModel<MovieVideosResponse>> getMovieVideos(int movieId) async {
    final apiEndpoints = apiController.apiEndpoints;

    final apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.movieVideoResponse,
      url: apiEndpoints.apiMoviesVideos(movieId),
    );

    final apiResponseModel = await apiController.callApi<MovieVideosResponse>(apiCallModel: apiCallModel);

    return apiResponseModel;
  }



  Future<List<Map<String, dynamic>>> _fetchMoviesFromIds(List<dynamic> ids) async {
    if (ids.isEmpty) return [];
    final moviesCollection = FirebaseFirestore.instance.collection('movies'); // or 'movie'
    List<Map<String, dynamic>> results = [];

    for (String id in ids) {
      final doc = await moviesCollection.doc(id).get();
      if (doc.exists) results.add({'id': doc.id, ...doc.data()!});
    }

    return results;
  }

  Future<DataResponseModel<ActorDetailModel>> getActorDetails(int actorId) async {
    final apiCallModel = await apiController.getApiCallModelFromData<String>(
      restCallType: RestCallType.simpleGetCall,
      parsingType: ModelDataParsingType.actorDetailModel, // Define in enum
      url: "https://api.themoviedb.org/3/person/$actorId?api_key=fc6b0f8734f6d710fed11de93fc496cc&append_to_response=combined_credits",
    );

    return await apiController.callApi<ActorDetailModel>(apiCallModel: apiCallModel);
  }
}
