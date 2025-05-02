// import '../../configs/typedefs.dart';
// import '../../models/academy/course/data_model/course_model.dart';
// import '../common/common_provider.dart';
//
// class AcademicProvider extends CommonProvider {
//   AcademicProvider() {
//     academicsList = CommonProviderListParameter<CourseModel>(
//       list: [],
//       notify: notify,
//     );
//     lastAcademicsDocument = CommonProviderPrimitiveParameter<MyFirestoreQueryDocumentSnapshot?>(
//       value: null,
//       notify: notify,
//     );
//     hasMoreAcademics = CommonProviderPrimitiveParameter<bool>(
//       value: true,
//       notify: notify,
//     );
//     isAcademicsFirstTimeLoading = CommonProviderPrimitiveParameter<bool>(
//       value: false,
//       notify: notify,
//     );
//     isAcademicsLoading = CommonProviderPrimitiveParameter<bool>(
//       value: false,
//       notify: notify,
//     );
//
//     myAcademics = CommonProviderListParameter<CourseModel>(
//       list: [],
//       notify: notify,
//     );
//     isMyAcademicsFirstTimeLoading = CommonProviderPrimitiveParameter<bool>(
//       value: false,
//       notify: notify,
//     );
//     userId = CommonProviderPrimitiveParameter<String>(
//       value: "",
//       notify: notify,
//     );
//   }
//
//   //region Courses Paginated List
//   late CommonProviderListParameter<CourseModel> academicsList;
//
//   int get coursesLength => academicsList.getList(isNewInstance: false).length;
//
//   late CommonProviderPrimitiveParameter<MyFirestoreQueryDocumentSnapshot?> lastAcademicsDocument;
//   late CommonProviderPrimitiveParameter<bool> hasMoreAcademics;
//   late CommonProviderPrimitiveParameter<bool> isAcademicsFirstTimeLoading;
//   late CommonProviderPrimitiveParameter<bool> isAcademicsLoading;
//
//   //endregion
//
//   //region My Courses List
//   late CommonProviderListParameter<CourseModel> myAcademics;
//
//   int get myAcademicsLength => myAcademics.getList(isNewInstance: false).length;
//
//   late CommonProviderPrimitiveParameter<bool> isMyAcademicsFirstTimeLoading;
//   late CommonProviderPrimitiveParameter<String> userId;
//
//   //endregion
//
//   void reset({bool isNotify = true}) {
//     academicsList.setList(list: [], isNotify: false);
//     lastAcademicsDocument.set(value: null, isNotify: false);
//     hasMoreAcademics.set(value: true, isNotify: false);
//     isAcademicsFirstTimeLoading.set(value: false, isNotify: false);
//     isAcademicsLoading.set(value: false, isNotify: false);
//
//     myAcademics.setList(list: [], isNotify: false);
//     isAcademicsFirstTimeLoading.set(value: false, isNotify: false);
//     userId.set(value: "", isNotify: isNotify);
//   }
// }