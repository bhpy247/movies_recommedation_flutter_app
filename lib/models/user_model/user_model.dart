import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/my_utils.dart';
import '../../../utils/parsing_helper.dart';

class UserModel {
  String id = "";
  String name = "";
  String email = "";

  Timestamp? createdTime;
  Timestamp? updatedTime;

  UserModel({
    this.id = "",
    this.name = "",
    this.email = "",

    this.createdTime,
    this.updatedTime,
  }) ;

  UserModel.fromMap(Map<String, dynamic> map) {
    initializeFromMap(map);
  }

  void updateFromMap(Map<String, dynamic> map) {
    initializeFromMap(map);
  }

  void initializeFromMap(Map<String, dynamic> map) {
    id = ParsingHelper.parseStringMethod(map['id']);
    name = ParsingHelper.parseStringMethod(map['name']);
    email = ParsingHelper.parseStringMethod(map['email']);
    createdTime = ParsingHelper.parseTimestampMethod(map['createdTime']);
    updatedTime = ParsingHelper.parseTimestampMethod(map['updatedTime']);
  }

  Map<String, dynamic> toMap({bool toJson = false}) {
    return <String, dynamic>{
      "id" : id,
      "name" : name,
      "email" : email,

      "createdTime" : toJson ? createdTime?.toDate().millisecondsSinceEpoch : createdTime,
      "updatedTime" : toJson ? updatedTime?.toDate().millisecondsSinceEpoch : updatedTime,
    };
  }

  @override
  String toString() {
    return MyUtils.encodeJson(toMap(toJson: true));
  }
}