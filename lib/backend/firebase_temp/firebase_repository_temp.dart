// import 'package:flutter_app/configs/constants.dart';
// import 'package:flutter_app/configs/typedefs.dart';
// import 'package:flutter_app/models/academy/course/data_model/course_model.dart';
// import 'package:flutter_app/utils/extensions.dart';
// import 'package:flutter_app/utils/my_print.dart';
// import 'package:flutter_app/utils/myutils.dart';
//
// class AcademicsRepository {
//   Future<CourseModel?> getCourseModelFromCourseId({required String courseId}) async {
//     String tag = MyUtils.getNewId();
//     MyPrint.printOnConsole("AcademicsRepository().getCourseModelFromCourseId() called with courseId:'$courseId'", tag: tag);
//
//     CourseModel? courseModel;
//
//     if (courseId.isEmpty) {
//       MyPrint.printOnConsole("Returning from AcademicsRepository().getCourseModelFromCourseId() because courseId is empty", tag: tag);
//       return courseModel;
//     }
//
//     MyFirestoreDocumentSnapshot documentSnapshot = await FirebaseNodes.coursesDocumentReference(courseId: courseId).get();
//     if (documentSnapshot.exists && documentSnapshot.data().checkNotEmpty) {
//       courseModel = CourseModel.fromMap(documentSnapshot.data()!);
//     }
//
//     MyPrint.printOnConsole("Final courseModel Not Null:${courseModel != null}", tag: tag);
//
//     return courseModel;
//   }
// }