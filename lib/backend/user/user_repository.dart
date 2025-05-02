import 'package:cloud_firestore/cloud_firestore.dart';

import '../../configs/constants.dart';
import '../../configs/typedefs.dart';
import '../../models/common/new_document_data_model.dart';
import '../../models/user_model/user_model.dart';
import '../../utils/my_print.dart';
import '../../utils/my_utils.dart';

class UserRepository {
  Future<UserModel?> getUserModelFromId({required String userId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("UserRepository().getUserModelFromId() called with userId:'$userId'", tag: tag);

    if (userId.isEmpty) {
      MyPrint.printOnConsole("Returning from UserRepository().getUserModelFromId() because userId is empty", tag: tag);
      return null;
    }

    try {
      MyFirestoreDocumentSnapshot snapshot = await FirebaseNodes.userDocumentReference(userId: userId).get();
      MyPrint.printOnConsole("snapshot.exists:'${snapshot.exists}'", tag: tag);
      MyPrint.printOnConsole("snapshot.data():'${snapshot.data()}'", tag: tag);

      if (snapshot.exists && (snapshot.data()?.isNotEmpty ?? false)) {
        return UserModel.fromMap(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e, s) {
      MyPrint.printOnConsole("Error in UserRepository().getUserModelFromId():'$e'", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
      return null;
    }
  }

  Future<bool> createNewUser({required UserModel userModel}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("UserRepository().createNewUser() called with userModel:'$userModel'", tag: tag);

    if (userModel.id.isEmpty) {
      MyPrint.printOnConsole("Returning from UserRepository().createNewUser() because userId is empty", tag: tag);
      return false;
    }

    bool isCreated = false;

    try {
      NewDocumentDataModel newDocumentDataModel = await MyUtils.getNewDocIdAndTimeStamp(isGetTimeStamp: true);
      MyPrint.printOnConsole("newDocumentDataModel:'$newDocumentDataModel'", tag: tag);

      userModel.createdTime = newDocumentDataModel.timestamp;

      MyPrint.printOnConsole("Final userModel:'$userModel'", tag: tag);

      await FirebaseNodes.userDocumentReference(userId: userModel.id).set(userModel.toMap());
      isCreated = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Creating User Document in Firestore in UserRepository().createNewUser():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("isCreated:'$isCreated'", tag: tag);

    return isCreated;
  }

  // Future<bool> updateUserProfileData({required ProfileUpdateRequestModel requestModel}) async {
  //   String tag = MyUtils.getNewId();
  //   MyPrint.printOnConsole("UserRepository().updateUserProfileData() called with requestModel:'$requestModel'", tag: tag);
  //
  //   if (requestModel.id.isEmpty) {
  //     MyPrint.printOnConsole("Returning from UserRepository().updateUserProfileData() because userId is empty", tag: tag);
  //     return false;
  //   }
  //
  //   bool isUpdated = false;
  //
  //   try {
  //     NewDocumentDataModel newDocumentDataModel = await MyUtils.getNewDocIdAndTimeStamp(isGetTimeStamp: true);
  //     MyPrint.printOnConsole("newDocumentDataModel:'$newDocumentDataModel'", tag: tag);
  //
  //     requestModel.updatedTime = newDocumentDataModel.timestamp;
  //
  //     MyPrint.printOnConsole("Final requestModel:'$requestModel'", tag: tag);
  //
  //     await FirebaseNodes.userDocumentReference(userId: requestModel.id).update(requestModel.toMap());
  //     isUpdated = true;
  //   } catch (e, s) {
  //     MyPrint.printOnConsole("Error in Creating User Document in Firestore in UserRepository().updateUserProfileData():$e", tag: tag);
  //     MyPrint.printOnConsole(s, tag: tag);
  //   }
  //
  //   MyPrint.printOnConsole("isUpdated:'$isUpdated'", tag: tag);
  //
  //   return isUpdated;
  // }

  Future<bool> updateLastChapterPlayedInCourseForUser({required String userId, required String courseId, required String chapterId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("UserRepository().updateLastChapterPlayedInCourseForUser() called for userId:'$userId', courseId:'$courseId', chapterId:'$chapterId'", tag: tag);

    bool isUpdated = false;

    try {
      await FirebaseNodes.userDocumentReference(userId: userId).update({
        "myCoursesData.$courseId.lastPlayedChapterId": chapterId,
      });
      isUpdated = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in UserRepository().updateLastChapterPlayedInCourseForUser():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("isUpdated:$isUpdated", tag: tag);

    return isUpdated;
  }

  Future<bool> updateNotificationToken({required String userId, required String token}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("UserRepository().updateNotificationToken() called for userId:'$userId', token:'$token'", tag: tag);

    bool isUpdated = false;

    try {
      await FirebaseNodes.userDocumentReference(userId: userId).update({
        "notificationToken": token,
      });
      isUpdated = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in UserRepository().updateNotificationToken():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("isUpdated:$isUpdated", tag: tag);

    return isUpdated;
  }

  Future<bool> deleteUserAccount({required String userId}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("UserRepository().deleteUserAccount() called with userId:'$userId'", tag: tag);

    if(userId.isEmpty) {
      MyPrint.printOnConsole("Returning from UserRepository().deleteUserAccount() because userId is empty", tag: tag);
      return false;
    }

    bool isDeleted = false;

    try {
      await FirebaseNodes.userDocumentReference(userId: userId).delete();
      isDeleted = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in UserRepository().deleteUserAccount():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("Final isDeleted:$isDeleted", tag: tag);

    return isDeleted;
  }

  Future<bool> updateUserCourseValidityData({required String userId, required Map<String, int> courseValidityDaya}) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole("UserRepository().updateUserCourseValidityData() called with userId:'$userId', courseValidityDaya:'$courseValidityDaya'", tag: tag);

    courseValidityDaya.removeWhere((key, value) => key.isEmpty);

    if(userId.isEmpty) {
      MyPrint.printOnConsole("Returning from UserRepository().updateUserCourseValidityData() because userId is empty", tag: tag);
      return false;
    }
    else if(courseValidityDaya.isEmpty) {
      MyPrint.printOnConsole("Returning from UserRepository().updateUserCourseValidityData() because courseValidityDaya is empty", tag: tag);
      return false;
    }

    bool isUpdated = false;

    try {
      Map<String, dynamic> updateMap = Map<String, dynamic>.from(courseValidityDaya.map((key, value) {
        return MapEntry<String, dynamic>("myCoursesData.$key.validityInDays", value);
      }));
      updateMap["lastExpiryChecked"] = FieldValue.serverTimestamp();

      await FirebaseNodes.userDocumentReference(userId: userId).update(updateMap);
      isUpdated = true;
    }
    catch(e, s) {
      MyPrint.printOnConsole("Error in Creating User Document in Firestore in UserRepository().updateUserCourseValidityData():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("isUpdated:'$isUpdated'", tag: tag);

    return isUpdated;
  }
}