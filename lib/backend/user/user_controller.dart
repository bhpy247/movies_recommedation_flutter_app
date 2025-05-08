
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/utils/extensions.dart';
import 'package:provider/provider.dart';

import '../../models/user_model/user_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';
import '../authentication/authentication_controller.dart';
import '../authentication/authentication_provider.dart';
import '../navigation/navigation_controller.dart';
import 'user_repository.dart';

class UserController {
  late AuthenticationProvider _authenticationProvider;
  late UserRepository _userRepository;

  UserController({
    AuthenticationProvider? authenticationProvider,
    UserRepository? repository,
  }) {
    _authenticationProvider = authenticationProvider ?? AuthenticationProvider();
    _userRepository = repository ?? UserRepository();
  }

  AuthenticationProvider get authenticationProvider => _authenticationProvider;

  UserRepository get userRepository => _userRepository;

  Future<bool> createNewUser({required UserModel userModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("UserController().createNewUser() called with userModel:'$userModel'", tag: tag);

    bool isCreated = false;

    try {
      isCreated = await userRepository.createNewUser(userModel: userModel);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Creating User Document in UserController().createNewUser():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("isCreated:'$isCreated'", tag: tag);

    return isCreated;
  }

  // Profile methods
  // Future<void> loadProfile(BuildContext context, UserModel userModel) async {
  //
  //   _authenticationProvider.setCurrentUser(userModel);
  // }

  // Favorites methods
  Future<bool> addToFavorites(BuildContext context, int movieId) async {
   
    final currentUser = _authenticationProvider.userModel.get();
    if (currentUser == null) return false;

    if (!currentUser.favorites.contains(movieId)) {
      try {
        await _userRepository.updateUserField(
          userId: currentUser.uid,
          field: 'favorites',
          value: FieldValue.arrayUnion([movieId]),
        );

        // Update local state
        _authenticationProvider.updateCurrentUser(
          currentUser.copyWith(
            favorites: [...currentUser.favorites, movieId],
          ),
        );
        return true;
      } catch (e) {
        MyPrint.printOnConsole("Error adding to favorites: $e");
        return false;
      }
    }
    return false;
  }

  Future<bool> removeFromFavorites(BuildContext context, int movieId) async {
   
    final currentUser = _authenticationProvider.userModel.get();
    if (currentUser == null) return false;

    if (currentUser.favorites.contains(movieId)) {
      try {
        await _userRepository.updateUserField(
          userId: currentUser.uid,
          field: 'favorites',
          value: FieldValue.arrayRemove([movieId]),
        );

        // Update local state
        _authenticationProvider.updateCurrentUser(
          currentUser.copyWith(
            favorites: currentUser.favorites.where((id) => id != movieId).toList(),
          ),
        );
        return true;
      } catch (e) {
        MyPrint.printOnConsole("Error removing from favorites: $e");
        return false;
      }
    }
    return false;
  }

  Future<bool> updateFavorites(BuildContext context, List<int> favorites) async {
   
    final currentUser = _authenticationProvider.userModel.get();
    if (currentUser == null) return false;

    try {
      await _userRepository.updateUserField(
        userId: currentUser.uid,
        field: 'favorites',
        value: favorites,
      );

      // Update local state
      _authenticationProvider.updateCurrentUser(
        currentUser.copyWith(favorites: favorites),
      );
      return true;
    } catch (e) {
      MyPrint.printOnConsole("Error updating favorites: $e");
      return false;
    }
  }

  // Watchlist methods (similar to favorites)
  Future<bool> addToWatchlist(BuildContext context, int movieId) async {
   
    final currentUser = _authenticationProvider.userModel.get();
    if (currentUser == null) return false;

    if (!currentUser.watchlist.contains(movieId)) {
      try {
        await _userRepository.updateUserField(
          userId: currentUser.uid,
          field: 'watchlist',
          value: FieldValue.arrayUnion([movieId]),
        );

        _authenticationProvider.updateCurrentUser(
          currentUser.copyWith(
            watchlist: [...currentUser.watchlist, movieId],
          ),
        );
        return true;
      } catch (e) {
        MyPrint.printOnConsole("Error adding to watchlist: $e");
        return false;
      }
    }
    return false;
  }

  Future<bool> removeFromWatchlist(BuildContext context, int movieId) async {
   
    final currentUser = _authenticationProvider.userModel.get();
    if (currentUser == null) return false;

    if (currentUser.watchlist.contains(movieId)) {
      try {
        await _userRepository.updateUserField(
          userId: currentUser.uid,
          field: 'watchlist',
          value: FieldValue.arrayRemove([movieId]),
        );

        _authenticationProvider.updateCurrentUser(
          currentUser.copyWith(
            watchlist: currentUser.watchlist.where((id) => id != movieId).toList(),
          ),
        );
        return true;
      } catch (e) {
        MyPrint.printOnConsole("Error removing from watchlist: $e");
        return false;
      }
    }
    return false;
  }

  Future<bool> updateWatchlist(BuildContext context, List<int> watchlist) async {
   
    final currentUser = _authenticationProvider.userModel.get();
    if (currentUser == null) return false;

    try {
      await _userRepository.updateUserField(
        userId: currentUser.uid,
        field: 'watchlist',
        value: watchlist,
      );

      _authenticationProvider.updateCurrentUser(
        currentUser.copyWith(watchlist: watchlist),
      );
      return true;
    } catch (e) {
      MyPrint.printOnConsole("Error updating watchlist: $e");
      return false;
    }
  }

  // Friend-related methods
  Future<bool> addFriendRequest(BuildContext context, String friendId) async {
   
    final currentUser = _authenticationProvider.userModel.get();
    if (currentUser == null) return false;

    if (!currentUser.friendRequests.contains(friendId)) {
      try {
        await _userRepository.updateUserField(
          userId: currentUser.uid,
          field: 'friendRequests',
          value: FieldValue.arrayUnion([friendId]),
        );

        _authenticationProvider.updateCurrentUser(
          currentUser.copyWith(
            friendRequests: [...currentUser.friendRequests, friendId],
          ),
        );
        return true;
      } catch (e) {
        MyPrint.printOnConsole("Error adding friend request: $e");
        return false;
      }
    }
    return false;
  }

  // Similar methods for other friend operations:
  // removeFromFriendRequests, updateFriendRequests,
  // addToFriends, removeFromFriends, updateFriends,
  // addToSentFriendRequests, removeFromSentFriendRequests, updateSentFriendRequests

  // Clear user state
  Future<void> clearUserState(BuildContext context) async {
   
    // _authenticationProvider.clearCurrentUser();
  }
}