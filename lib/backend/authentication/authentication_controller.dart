import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moviesapp/api/api_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_operation_parameters.dart';
import 'package:moviesapp/backend/navigation/navigation_type.dart';
import 'package:moviesapp/configs/constants.dart';
import 'package:moviesapp/models/authentication/login_request_model.dart';
import 'package:moviesapp/models/common/data_response_model.dart';
import 'package:moviesapp/models/user_model/update_user_model.dart';
import 'package:moviesapp/models/user_model/user_model.dart';
import 'package:moviesapp/utils/extensions.dart';
import 'package:moviesapp/utils/my_print.dart';
import 'package:moviesapp/utils/parsing_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/constants.dart';
import '../../models/authentication/login_request_model.dart';
import '../../utils/my_toast.dart';
import '../../utils/my_utils.dart';
import '../../views/authentication/screens/login_screen.dart';
import '../../views/common/components/my_cupertino_dialog_widget.dart';
import '../user/user_controller.dart';
import 'authentication_provider.dart';
import 'authentication_repository.dart';

class AuthenticationController {
  late AuthenticationProvider _authenticationProvider;
  late AuthenticationRepository _authenticationRepository;

  AuthenticationController({required AuthenticationProvider? authenticationProvider, AuthenticationRepository? repository}) {
    _authenticationProvider = authenticationProvider ?? AuthenticationProvider();
    _authenticationRepository = repository ?? AuthenticationRepository(apiController: ApiController());
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthenticationProvider get authenticationProvider => _authenticationProvider;

  AuthenticationRepository get authenticationRepository => _authenticationRepository;

  Future<bool> isUserLoggedIn() async {
    AuthenticationProvider provider = authenticationProvider;

    User? firebaseUser = await FirebaseAuth.instance.authStateChanges().first;
    MyPrint.printOnConsole("FirebaseAuth.instance.currentUser != null: ${FirebaseAuth.instance.currentUser != null}");
    final user = FirebaseAuth.instance.currentUser;
    print("Current UID: ${user?.uid}");
    if (firebaseUser == null) {
      if (kIsWeb) {
        await Future.delayed(const Duration(seconds: 2));
        firebaseUser = await FirebaseAuth.instance.authStateChanges().first;
      }
    }

    if (firebaseUser != null && (firebaseUser.email ?? "").isNotEmpty) {
      provider.setAuthenticationDataFromFirebaseUser(firebaseUser: firebaseUser, isNotify: false);
      return true;
    } else {
      logout();
      return false;
    }
  }

  Future<bool> checkUserWithIdExistOrNotAndIfNotExistThenCreate({required String userId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AuthenticationController().checkUserWithIdExistOrNotAndIfNotExistThenCreate() called with userId:'$userId'", tag: tag);

    bool isUserExist = false;

    if (userId.isEmpty) return isUserExist;

    UserController userController = UserController();

    try {
      UserModel? userModel = await userController.userRepository.getUserModelFromId(userId: userId);
      MyPrint.printOnConsole("userModel:'$userModel'", tag: tag);

      if (userModel != null) {
        isUserExist = true;

        authenticationProvider.userModel.set(value: userModel, isNotify: false);
      } else {
        UserModel createdUserModel = await createUserModelFromSharedPref();
        bool isCreated = await userController.createNewUser(userModel: createdUserModel);
        MyPrint.printOnConsole("isUserCreated:'$isCreated'", tag: tag);

        if (isCreated) {
          authenticationProvider.userModel.set(value: createdUserModel, isNotify: false);
        }
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in AuthenticationController().checkUserWithIdExistOrNotAndIfNotExistThenCreate():'$e'", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isUserExist;
  }

  Future<bool> getUserModel({required String userId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("AuthenticationController().checkUserWithIdExistOrNotAndIfNotExistThenCreate() called with userId:'$userId'", tag: tag);

    bool isUserExist = false;

    if (userId.isEmpty) return isUserExist;

    UserController userController = UserController();

    try {
      UserModel? userModel = await userController.userRepository.getUserModelFromId(userId: userId);
      MyPrint.printOnConsole("userModel:'$userModel'", tag: tag);

      if (userModel != null) {
        isUserExist = true;

        authenticationProvider.userModel.set(value: userModel, isNotify: false);
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in AuthenticationController().checkUserWithIdExistOrNotAndIfNotExistThenCreate():'$e'", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    return isUserExist;
  }

  Future<User?> loginWithEmail({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      // Store session data
      await _storeUserData(userCredential.user);
      getUserModel(userId: userCredential.user?.uid ?? "");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Login error: ${e.code} - ${e.message}');
      throw _convertFirebaseError(e);
    } catch (e) {
      debugPrint('Unexpected login error: $e');
      throw 'Login failed. Please try again.';
    }
  }

  Future<UserModel> createUserModelFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();

    String userID = prefs.getString(SharePreferenceKeys.userIdKey) ?? "";
    String email = prefs.getString(SharePreferenceKeys.authenticatedUserEmail) ?? "";
    String name = prefs.getString(SharePreferenceKeys.userNameKey) ?? "";
    String token = prefs.getString(SharePreferenceKeys.bearerToken) ?? "";
    String userName = prefs.getString(SharePreferenceKeys.authenticatedUserName) ?? "";

    UserModel userModel = UserModel(email: email, displayName: name, uid: userID, createdTime: Timestamp.now());

    return userModel;
  }

  Future<void> _storeUserData(User? user) async {
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharePreferenceKeys.userIdKey, user.uid);
    await prefs.setString(SharePreferenceKeys.authenticatedUserEmail, user.email ?? '');
    await prefs.setString(SharePreferenceKeys.userNameKey, user.displayName ?? '');
    await prefs.setString(SharePreferenceKeys.bearerToken, await user.getIdToken() ?? '');
    await prefs.setString(SharePreferenceKeys.authenticatedUserName, user.email ?? "");
    MyPrint.printOnConsole("in store data ${prefs.getString("key")}");

    authenticationProvider.userModel.set(value: UserModel(uid: user.uid, displayName: user.displayName ?? "", email: user.email ?? ""));
    authenticationProvider.userId.set(value: user.uid);
  }

  String _convertFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid email or password';
      case 'email-already-in-use':
        return 'An account already exists with this email';
      case 'weak-password':
        return 'Password should be at least 6 characters';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      default:
        return e.message ?? 'An unknown error occurred';
    }
  }

  Future<User?> registerWithEmail({required String email, required String password, required String name}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      // Update user profile with name
      UserController userController = UserController();
      String userId = userCredential.user?.uid ?? "";
      String userEmail = userCredential.user?.email ?? "";

      UserModel createdUserModel = UserModel(uid: userId, email: userEmail, displayName: name, username: name);
      bool isCreated = await userController.createNewUser(userModel: createdUserModel);
      MyPrint.printOnConsole("isUserCreated:'$isCreated'");

      if (isCreated) {
        authenticationProvider.userModel.set(value: createdUserModel, isNotify: false);
      }
      // Store session data
      await _storeUserData(userCredential.user);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      debugPrint('Registration error: ${e.code} - ${e.message}');
      throw _convertFirebaseError(e);
    } catch (e) {
      debugPrint('Unexpected registration error: $e');
      throw 'Registration failed. Please try again.';
    }
  }

  Future<bool> logout({
    bool isShowConfirmationDialog = false,
    bool isNavigateToLogin = false,
    bool isForceLogout = false,
    String forceLogoutMessage = "",
  }) async {
    BuildContext? context = NavigationController.mainScreenNavigator.currentContext;

    bool? isLoggedOut;
    if (context != null && isShowConfirmationDialog) {
      isLoggedOut = await showDialog(
        context: context,
        builder: (context) {
          return MyCupertinoAlertDialogWidget(
            title: "Logout",
            description: "Are you sure want to logout?",
            neagtiveText: "No",
            positiveText: "Yes",
            negativeCallback: () => Navigator.pop(context, false),
            positiviCallback: () async {
              Navigator.pop(context, true);
            },
          );
        },
      );
    } else {
      isLoggedOut = true;
    }
    MyPrint.printOnConsole("IsLoggedOut:$isLoggedOut");

    if (isLoggedOut != true) {
      return false;
    }

    try {
      Future.wait([
        FirebaseAuth.instance
            .signOut()
            .then((value) {
              MyPrint.printOnConsole("Logged Out User From Firebase Auth");
            })
            .catchError((e, s) {
              MyPrint.printOnConsole("Error in Logging Out User From Firebase:$e");
              MyPrint.printOnConsole(s);
            }),
      ]);
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Logging Out:$e");
      MyPrint.printOnConsole(s);
    }

    isLoggedOut = true;

    if (isNavigateToLogin && context != null && context.checkMounted() && context.mounted) {
      if (isForceLogout) {
        Future.delayed(const Duration(seconds: 1), () {
          if (LoginScreen.context != null) {
            MyToast.showError(context: LoginScreen.context!, msg: forceLogoutMessage);
          }
        });
      }

      NavigationController.navigateToLoginScreen(
        navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamedAndRemoveUntil),
      );
    }

    return isLoggedOut;
  }
}
