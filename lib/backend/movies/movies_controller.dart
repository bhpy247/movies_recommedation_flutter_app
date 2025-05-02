import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/backend/movies/movies_provider.dart';
import 'package:moviesapp/models/movies/response_model/movies_response_model.dart';
import 'package:moviesapp/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../api/api_controller.dart';
import '../../models/common/data_response_model.dart';
import '../../utils/my_print.dart';
import '../authentication/authentication_repository.dart';
import 'movies_repository.dart';

class MoviesController {
  late MoviesProvider _moviesProvider;
  late MoviesRepository _moviesRepository;

  MoviesController({
    required MoviesProvider? moviesProvider,
    MoviesRepository? repository,
  }) {
    _moviesProvider = moviesProvider ?? MoviesProvider();
    _moviesRepository = repository ?? MoviesRepository(apiController: ApiController());
  }

  MoviesProvider get moviesProvider => _moviesProvider;

  MoviesRepository get moviesRepository => _moviesRepository;

//
//
//
//   Future<void> getMoviesList(BuildContext context, {bool isRefresh = true, bool withoutNotify = false, bool fetchFromElastic = true, bool isFromSplashScreen = false}) async {
//   MyPrint.printOnConsole("Get MovieList called with refresh:$isRefresh");
//
//   // if(!ConnectionController().checkConnection()) {
//   //   return;
//   // }
//
//   MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
//   // UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
//
//   try {
//     if (isRefresh) {
//       MyPrint.printOnConsole("Refresh");
//
//       //For Getting Filter Users
//       moviesProvider.isFirstTimeLoading = true;
//       moviesProvider.isUsersLoading = false; // track if users fetching
//       moviesProvider.hasMore = true; // flag for more users available or not
//       moviesProvider.elasticDocumentIndex = 0; // flag for last document from where next 10 records to be fetched
//       moviesProvider.moviesList.clear();
//
//       //moviesProvider.pageController = PreloadPageController(initialPage: 0);
//     }
//
//     if (!moviesProvider.hasMore) {
//       MyPrint.printOnConsole('No More Users');
//       return;
//     }
//     if (moviesProvider.isUsersLoading) return;
//
//     if (isFromSplashScreen) {
//       moviesProvider.documentLimit = 5;
//     }
//     else {
//       moviesProvider.documentLimit = moviesProvider.maxDocumentLimit;
//     }
//
//     moviesProvider.isUsersLoading = true;
//     if (!withoutNotify) moviesProvider.notifyListeners();
//
//     // List<String> userIds = moviesProvider.moviesList.map((e) => e.id ?? "").toList();
//     // MyPrint.printOnConsole("Existing User Ids:$userIds");
//     List<MoviesList> moviesList = [];
//
//
//
//     int count = 0;
//     while ((moviesProvider.hasMore) && moviesList.length < (moviesProvider.documentLimit)) {
//       MyPrint.printOnConsole("While Called");
//
//
//       DataResponseModel<MoviesResponseModel> moviesResponseModel = await _moviesRepository.getMovies(moviesProvider.documentLimit);
//       MyPrint.printOnConsole("Data: ${moviesResponseModel.data?.toJson() ?? " "}");
//
//       if (moviesResponseModel.data == null) return ;
//       MyPrint.printOnConsole(moviesResponseModel.data?.toJson() ?? "");
//
//       if (moviesResponseModel.statusCode == 200) {
//         moviesProvider.moviesList.addAll(moviesResponseModel.data?.moviesList ?? []);
//       }
//
//       moviesProvider.documentLimit = moviesProvider.maxDocumentLimit;
//
//       moviesProvider.isFirstTimeLoading = false;
//
//       moviesProvider.isUsersLoading = false;
//       moviesProvider.notifyListeners();
//       MyPrint.printOnConsole("Searched Movies Length : ${moviesProvider.moviesList.length}");
//     }
//   }
//   catch (e, s) {
//     MyPrint.printOnConsole("Error:" + e.toString());
//     MyPrint.printOnConsole(s);
//     moviesProvider.isFirstTimeLoading = false;
//     moviesProvider.isUsersLoading = false;
//     moviesProvider.hasMore = false;
//     moviesProvider.notifyListeners();
//   }
// }

  Future<void> getMoviesList(BuildContext context, {bool isRefresh = true}) async {



    try {
      final moviesProvider = context.read<MoviesProvider>();

      if (isRefresh) {
        moviesProvider.resetPagination();
      }

      if (!moviesProvider.hasMore.get() || moviesProvider.isLoading.get()) {
        return;
      }

      moviesProvider.isLoading.set(value: true);

      final DataResponseModel<MoviesResponseModel> response =
      await _moviesRepository.getMovies(moviesProvider.currentPage.get());

      MyPrint.printOnConsole("Data: ${response.data?.toJson() ?? " "}");

      if (response.data == null) {
        // moviesProvider.errorMessage.set('No data received from server');
        return;
      }

      MyPrint.printOnConsole(response.data?.toJson() ?? "");

      if (response.statusCode == 200) {
        final newMovies = response.data?.moviesList ?? [];
        if (isRefresh) {
          _moviesProvider.moviesList.setList(list: newMovies);
        } else {
          _moviesProvider.addMovies(newMovies);
        }

        // Update pagination state
        _moviesProvider.hasMore.set(value:newMovies.length >= _moviesProvider.currentPage.get());
        _moviesProvider.currentPage.set(value:_moviesProvider.currentPage.get() + 1);
      }

      } catch (e, s) {
      MyPrint.printOnConsole("Error:" + e.toString());
      MyPrint.printOnConsole(s);
      // moviesProvider.errorMessage.set('An error occurred: ${e.toString()}');
    } finally {
      moviesProvider.isLoading.set(value:false);
      moviesProvider.isFirstTimeLoading.set(value:false);
    }
  }

  Future<void> refreshMoviesList(BuildContext context) async {
    await getMoviesList(context, isRefresh: true);
  }
}