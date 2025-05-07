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
        return UserModel.fromJson(snapshot.data()!);
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

    if (userModel.uid.isEmpty) {
      MyPrint.printOnConsole("Returning from UserRepository().createNewUser() because userId is empty", tag: tag);
      return false;
    }

    bool isCreated = false;

    try {
      NewDocumentDataModel newDocumentDataModel = await MyUtils.getNewDocIdAndTimeStamp(isGetTimeStamp: true);
      MyPrint.printOnConsole("newDocumentDataModel:'$newDocumentDataModel'", tag: tag);

      userModel.createdTime = newDocumentDataModel.timestamp;

      MyPrint.printOnConsole("Final userModel:'$userModel'", tag: tag);

      await FirebaseNodes.userDocumentReference(userId: userModel.uid).set(userModel.toJson());
      isCreated = true;
    } catch (e, s) {
      MyPrint.printOnConsole("Error in Creating User Document in Firestore in UserRepository().createNewUser():$e", tag: tag);
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("isCreated:'$isCreated'", tag: tag);

    return isCreated;
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

  Future<bool> updateUserField({
    required String userId,
    required String field,
    required dynamic value,
  }) async {
    String tag = MyUtils.getNewId();
    MyPrint.printOnConsole(
      "UserRepository().updateUserField() called with userId:'$userId', field:'$field', value:'$value'",
      tag: tag,
    );

    if (userId.isEmpty) {
      MyPrint.printOnConsole(
        "Returning from UserRepository().updateUserField() because userId is empty",
        tag: tag,
      );
      return false;
    }

    bool isUpdated = false;

    try {
      await FirebaseNodes.userDocumentReference(userId: userId).update({
        field: value,
      });
      isUpdated = true;
    } catch (e, s) {
      MyPrint.printOnConsole(
        "Error in UserRepository().updateUserField():$e",
        tag: tag,
      );
      MyPrint.printOnConsole(s, tag: tag);
    }

    MyPrint.printOnConsole("isUpdated:$isUpdated", tag: tag);
    return isUpdated;
  }

}