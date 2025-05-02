//Shared Preference Keys
import 'package:moviesapp/configs/typedefs.dart';

import '../backend/common/firebase_controller.dart';

class SharePreferenceKeys {
  static const String bearerToken = "AuthToken";
  static const String appThemeMode = "themeMode";
  static const String selectedLanguage = "selectedLanguage";
  static const String isFirstTimeUser = "isFirstTimeUser";
  static const String userIdKey = "userIdKey";
  static const String userNameKey = "userNameKey";
}

class FirebaseNodes {
  //region Admin
  static const String adminCollection = "admin";

  static MyFirestoreCollectionReference get adminCollectionReference => FirestoreController.collectionReference(
    collectionName: adminCollection,
  );

  static MyFirestoreDocumentReference adminDocumentReference({String? documentId}) => FirestoreController.documentReference(
    collectionName: adminCollection,
    documentId: documentId,
  );

  //region Property Document
  static const String propertyDocument = "property";

  static MyFirestoreDocumentReference get adminPropertyDocumentReference => adminDocumentReference(
    documentId: propertyDocument,
  );
  //endregion

  //region About Document
  static const String aboutDocument = "about";

  static MyFirestoreDocumentReference get adminAboutDocumentReference => adminDocumentReference(
    documentId: aboutDocument,
  );
  //endregion

  //region FAQ Document
  static const String faqDocument = "faq";

  static MyFirestoreDocumentReference get adminFaqDocumentReference => adminDocumentReference(
    documentId: faqDocument,
  );
  //endregion

  //region Feedback Document
  static const String feedbackDocument = "feedback";

  static MyFirestoreDocumentReference get adminFeedbackDocumentReference => adminDocumentReference(
    documentId: feedbackDocument,
  );
  //endregion
  //endregion

  //region Courses Collection
  static const String coursesCollection = 'courses';

  static MyFirestoreCollectionReference get coursesCollectionReference => FirestoreController.collectionReference(
    collectionName: FirebaseNodes.coursesCollection,
  );

  static MyFirestoreDocumentReference coursesDocumentReference({String? courseId}) => FirestoreController.documentReference(
    collectionName: FirebaseNodes.coursesCollection,
    documentId: courseId,
  );
  //endregion

  //region User
  static const String usersCollection = "users";

  static MyFirestoreCollectionReference get usersCollectionReference => FirestoreController.collectionReference(
    collectionName: usersCollection,
  );

  static MyFirestoreDocumentReference userDocumentReference({String? userId}) => FirestoreController.documentReference(
    collectionName: usersCollection,
    documentId: userId,
  );
  //endregion

  //region Timestamp Collection
  static const String timestampCollection = "timestamp_collection";

  static MyFirestoreCollectionReference get timestampCollectionReference => FirestoreController.collectionReference(
    collectionName: timestampCollection,
  );
//endregion
}
