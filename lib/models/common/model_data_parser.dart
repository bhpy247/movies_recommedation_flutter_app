
import 'package:moviesapp/models/movies/response_model/movies_response_model.dart';

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
  quizQuestionResponseModel

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
