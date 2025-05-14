
import 'package:moviesapp/models/movies/response_model/actor_detail_model.dart';
import 'package:moviesapp/models/movies/response_model/cast_model.dart';
import 'package:moviesapp/models/movies/response_model/movie_videos_response.dart';
import 'package:moviesapp/models/movies/response_model/movies_detail_response_model.dart';
import 'package:moviesapp/models/movies/response_model/movies_response_model.dart';
import 'package:moviesapp/models/movies/response_model/similar_movie_list_model.dart';

import '../../utils/my_print.dart';
import '../../utils/parsing_helper.dart';
import '../user_model/user_model.dart';

typedef ModelDataParsingCallbackTypeDef<T> = T? Function({required dynamic decodedValue});

enum ModelDataParsingType {
  dynamic,
  string,
  bool,
  int,
  List,
  StringList,
  loginModel,
  moviesModel,
  quizQuestionResponseModel,
  moviesDetailResponseModel,
  castListModel,
  similarMoviesModel,
  movieVideoResponse,
  actorDetailModel

  //region App Module
  // CurrencyDataResponseModel,
}

class ModelDataParser {
  static Map<ModelDataParsingType, ModelDataParsingCallbackTypeDef> callsMap = <ModelDataParsingType, ModelDataParsingCallbackTypeDef>{
    ModelDataParsingType.dynamic: parseDynamic,
    ModelDataParsingType.string: parseString,
    ModelDataParsingType.bool: parseBool,
    ModelDataParsingType.int: parseInt,
    ModelDataParsingType.List: parseList,
    ModelDataParsingType.StringList: parseStringList,
    ModelDataParsingType.moviesModel: parseMovieModelResponseModel,
    ModelDataParsingType.moviesDetailResponseModel: parseMovieDetailModelResponseModel,
    ModelDataParsingType.castListModel: parseCastListResponseModel,
    ModelDataParsingType.similarMoviesModel: parseSimilarMovieResponseModel,
    ModelDataParsingType.movieVideoResponse: parseMovieResponseModel,
    ModelDataParsingType.actorDetailModel: parseActorDetailResponseModel,

    //region App Module
    // ModelDataParsingType.CurrencyDataResponseModel: parseCurrencyDataResponseModel,
  };

  static T? parseDataFromDecodedValue<T>({required ModelDataParsingType parsingType, dynamic decodedValue}) {
    ModelDataParsingCallbackTypeDef? type = callsMap[parsingType];
    MyPrint.printOnConsole("Parsing Callback:$type");

    if (type is ModelDataParsingCallbackTypeDef<T>) {
      MyPrint.printOnConsole("Parsing Callback Matched");
      return type(decodedValue: decodedValue);
    } else {
      MyPrint.printOnConsole("Parsing Callback Not Matched");
      return null;
    }
  }

  static dynamic parseDynamic({required dynamic decodedValue}) {
    return decodedValue;
  }

  static String parseString({required dynamic decodedValue}) {
    return ParsingHelper.parseStringMethod(decodedValue);
  }

  static bool parseBool({required dynamic decodedValue}) {
    return ParsingHelper.parseBoolMethod(decodedValue);
  }

  static int parseInt({required dynamic decodedValue}) {
    return ParsingHelper.parseIntMethod(decodedValue);
  }

  static List parseList({required dynamic decodedValue}) {
    return ParsingHelper.parseListMethod(decodedValue);
  }

  static List<String> parseStringList({required dynamic decodedValue}) {
    return ParsingHelper.parseListMethod<dynamic, String>(decodedValue);
  }

  static MoviesResponseModel? parseMovieModelResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return MoviesResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  static MovieDetailsModel? parseMovieDetailModelResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return MovieDetailsModel.fromJson(map);
    } else {
      return null;
    }
  }

  static CastResponseModel? parseCastListResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return CastResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  static SimilarMoviesResponseModel? parseSimilarMovieResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return SimilarMoviesResponseModel.fromJson(map);
    } else {
      return null;
    }
  }

  static MovieVideosResponse? parseMovieResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return MovieVideosResponse.fromJson(map);
    } else {
      return null;
    }
  }

  static ActorDetailModel? parseActorDetailResponseModel({required dynamic decodedValue}) {
    Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);

    if (map.isNotEmpty) {
      return ActorDetailModel.fromJson(map);
    } else {
      return null;
    }
  }

//region App Module
// static CurrencyDataResponseModel? parseCurrencyDataResponseModel({required dynamic decodedValue}) {
//   Map<String, dynamic> map = ParsingHelper.parseMapMethod(decodedValue);
//
//   if (map.isNotEmpty) {
//     return CurrencyDataResponseModel.fromMap(map);
//   } else {
//     return null;
//   }
// }

//endregion
}
