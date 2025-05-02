// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:provider/provider.dart';
//
// import '../../configs/constants.dart';
// import '../../configs/typedefs.dart';
// import '../../controllers/provider/user_provider.dart';
// import '../../models/academy/course/data_model/course_model.dart';
// import '../../utils/my_print.dart';
// import '../../utils/myutils.dart';
// import '../common/firestore_controller.dart';
// import '../navigation/navigation_controller.dart';
// import 'academics_provider.dart';
// import 'academics_repository.dart';
//
// class AcademicsController {
//   late AcademicsRepository _courseRepository;
//   late AcademicProvider _courseProvider;
//   late BuildContext _context;
//
//   AcademicsController({
//     required AcademicProvider? provider,
//     required BuildContext context,
//     AcademicsRepository? repository,
//   }) {
//     _courseRepository = repository ?? AcademicsRepository();
//     _courseProvider = provider ?? AcademicProvider();
//     _context = context;
//   }
//
//   BuildContext get context => _context;
//
//   AcademicsRepository get courseRepository => _courseRepository;
//
//   AcademicProvider get courseProvider => _courseProvider;
//
//   Future<List<CourseModel>> getCoursesPaginatedList({bool isRefresh = true, bool isFromCache = false, bool isNotify = true}) async {
//     String tag = MyUtils.getNewId();
//     MyPrint.printOnConsole("AcademicsController().getCoursesPaginatedList called with isRefresh:$isRefresh, isFromCache:$isFromCache", tag: tag);
//     UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
//     List<String> industryList = userProvider.getUserModel()?.industries.keys.toList() ?? <String>[];
//
//     AcademicProvider provider = courseProvider;
//
//     if (!isRefresh && isFromCache && provider.coursesLength > 0) {
//       MyPrint.printOnConsole("Returning Cached Data", tag: tag);
//       return provider.academicsList.getList(isNewInstance: true);
//     }
//
//     if (isRefresh) {
//       MyPrint.printOnConsole("Refresh", tag: tag);
//       provider.hasMoreAcademics.set(value: true, isNotify: false); // flag for more products available or not
//       provider.lastAcademicsDocument.set(value: null, isNotify: false); // flag for last document from where next 10 records to be fetched
//       provider.isAcademicsFirstTimeLoading.set(value: true, isNotify: false);
//       provider.isAcademicsLoading.set(value: false, isNotify: false);
//       provider.academicsList.setList(list: <CourseModel>[], isNotify: isNotify);
//     }
//
//     try {
//       if (!provider.hasMoreAcademics.get()) {
//         MyPrint.printOnConsole('No More Courses', tag: tag);
//         return provider.academicsList.getList(isNewInstance: true);
//       }
//       if (provider.isAcademicsLoading.get()) return provider.academicsList.getList(isNewInstance: true);
//
//       provider.isAcademicsLoading.set(value: true, isNotify: isNotify);
//
//       Query<Map<String, dynamic>> query =
//       FirebaseNodes.coursesCollectionReference.limit(AppConstants.coursesDocumentLimitForPagination).orderBy("createdTime", descending: true).where("enabled", isEqualTo: true);
//       MyPrint.printOnConsole("Industry list : ${industryList}");
//
//       if (industryList.isNotEmpty) {
//         query = query.where("industryNameList", arrayContainsAny: industryList);
//       }
//       //For Last Document
//       MyFirestoreDocumentSnapshot? snapshot = provider.lastAcademicsDocument.get();
//       if (snapshot != null) {
//         MyPrint.printOnConsole("LastDocument not null", tag: tag);
//         query = query.startAfterDocument(snapshot);
//       } else {
//         MyPrint.printOnConsole("LastDocument null", tag: tag);
//       }
//
//       QuerySnapshot<Map<String, dynamic>> querySnapshot = await query.get();
//       MyPrint.printOnConsole("Documents Length in Firestore for Courses:${querySnapshot.docs.length}", tag: tag);
//
//       if (querySnapshot.docs.length < AppConstants.coursesDocumentLimitForPagination) provider.hasMoreAcademics.set(value: false, isNotify: false);
//
//       if (querySnapshot.docs.isNotEmpty) provider.lastAcademicsDocument.set(value: querySnapshot.docs[querySnapshot.docs.length - 1], isNotify: false);
//
//       List<CourseModel> list = [];
//       for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
//         if ((documentSnapshot.data() ?? {}).isNotEmpty) {
//           CourseModel productModel = CourseModel.fromMap(documentSnapshot.data()!);
//           list.add(productModel);
//         }
//       }
//       provider.academicsList.setList(list: list, isClear: false, isNotify: false);
//       provider.isAcademicsFirstTimeLoading.set(value: false, isNotify: true);
//       provider.isAcademicsLoading.set(value: false, isNotify: true);
//       MyPrint.printOnConsole("Final Courses Length From Firestore:${list.length}", tag: tag);
//       MyPrint.printOnConsole("Final Courses Length in Provider:${provider.coursesLength}", tag: tag);
//       return list;
//     }
//     catch(e, s) {
//       MyPrint.printOnConsole("Error in AcademicsController().getCoursesPaginatedList():$e", tag: tag);
//       MyPrint.printOnConsole(s, tag: tag);
//       provider.academicsList.setList(list: [], isClear: true, isNotify: false);
//       provider.hasMoreAcademics.set(value: true, isNotify: false);
//       provider.lastAcademicsDocument.set(value: null, isNotify: false);
//       provider.isAcademicsFirstTimeLoading.set(value: false, isNotify: false);
//       provider.isAcademicsLoading.set(value: false, isNotify: true);
//       return [];
//     }
//   }
//
//   Future<List<CourseModel>> getMyCoursesList({bool isRefresh = true, required List<String> myCourseIds, bool isNotify = true}) async {
//     String tag = MyUtils.getNewId();
//     MyPrint.printOnConsole("AcademicsController().getMyCoursesList called with isRefresh:$isRefresh, myCourseIds:$myCourseIds, isNotify:$isNotify", tag: tag);
//
//     AcademicProvider provider = courseProvider;
//
//     if (!isRefresh) {
//       MyPrint.printOnConsole("Returning Cached Data", tag: tag);
//       return provider.myAcademics.getList(isNewInstance: true);
//     }
//
//     if (provider.isMyAcademicsFirstTimeLoading.get()) {
//       MyPrint.printOnConsole("Returning from AcademicsController().getMyCoursesList() because myCourses already fetching", tag: tag);
//       return provider.myAcademics.getList(isNewInstance: true);
//     }
//
//     MyPrint.printOnConsole("Refresh", tag: tag);
//     provider.isMyAcademicsFirstTimeLoading.set(value: true, isNotify: false);
//     provider.myAcademics.setList(list: <CourseModel>[], isNotify: isNotify);
//
//     try {
//       List<MyFirestoreQueryDocumentSnapshot> docs = await FirestoreController.getDocsFromCollection(
//         collectionReference: FirebaseNodes.coursesCollectionReference,
//         docIds: myCourseIds,
//       );
//       MyPrint.printOnConsole("Documents Length in Firestore for My Courses:${docs.length}", tag: tag);
//
//       List<CourseModel> list = [];
//       for (DocumentSnapshot<Map<String, dynamic>> documentSnapshot in docs) {
//         if ((documentSnapshot.data() ?? {}).isNotEmpty) {
//           CourseModel productModel = CourseModel.fromMap(documentSnapshot.data()!);
//           list.add(productModel);
//         }
//       }
//       provider.myAcademics.setList(list: list, isClear: true, isNotify: false);
//       provider.isMyAcademicsFirstTimeLoading.set(value: false, isNotify: true);
//       MyPrint.printOnConsole("Final Courses Length From Firestore:${list.length}", tag: tag);
//       MyPrint.printOnConsole("Final Courses Length in Provider:${provider.myAcademicsLength}", tag: tag);
//       return list;
//     }
//     catch(e, s) {
//       MyPrint.printOnConsole("Error in AcademicsController().getMyCoursesList():$e", tag: tag);
//       MyPrint.printOnConsole(s, tag: tag);
//       provider.myAcademics.setList(list: [], isClear: true, isNotify: false);
//       provider.isMyAcademicsFirstTimeLoading.set(value: false, isNotify: false);
//       return [];
//     }
//   }
//
//   static Future<void> launchGoogleFormInCourse({required String formUrl}) async {
//     if(formUrl.isEmpty) {
//       return;
//     }
//
//     BuildContext? context = NavigationController.mainScreenNavigator.currentContext;
//
//     String userName = "";
//
//     if(context != null) {
//       UserProvider userProvider = Provider.of<UserProvider>(NavigationController.mainScreenNavigator.currentContext!, listen: false);
//       userName = userProvider.getUserModel()?.uName ?? "";
//     }
//
//     formUrl = formUrl.replaceAll("{{name}}", userName);
//     MyPrint.printOnConsole("Final googleFormUrl:$formUrl");
//
//     MyUtils.launchUrl(url: formUrl);
//   }
// }