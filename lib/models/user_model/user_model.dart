import 'package:cloud_firestore/cloud_firestore.dart';

import '../../utils/parsing_helper.dart';

class UserModel {
  String displayName;
  String email;
  List<int> favorites;
  List<String> friendRequests;
  List<String> friends;
  String? photoUrl;
  List<String> sentFriendRequests;
  String uid;
  String username;
  List<int> watchlist;
  Timestamp? createdTime; // New timestamp field

  UserModel({
    this.displayName = "",
    this.email = "",
    List<int>? favorites,
    List<String>? friendRequests,
    List<String>? friends,
    this.photoUrl,
    List<String>? sentFriendRequests,
    this.uid = "",
    this.username = "",
    List<int>? watchlist,
    this.createdTime, // Added to constructor
  })  : favorites = favorites ?? [],
        friendRequests = friendRequests ?? [],
        friends = friends ?? [],
        sentFriendRequests = sentFriendRequests ?? [],
        watchlist = watchlist ?? [];

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      displayName: ParsingHelper.parseStringMethod(json['displayName']),
      email: ParsingHelper.parseStringMethod(json['email']),
      favorites: ParsingHelper.parseListMethod<dynamic, int>(json['favorites']),
      friendRequests: ParsingHelper.parseListMethod<dynamic, String>(json['friendRequests']),
      friends: ParsingHelper.parseListMethod<dynamic, String>(json['friends']),
      photoUrl: ParsingHelper.parseStringNullableMethod(json['photoUrl']),
      sentFriendRequests: ParsingHelper.parseListMethod<dynamic, String>(json['sentFriendRequests']),
      uid: ParsingHelper.parseStringMethod(json['uid']),
      username: ParsingHelper.parseStringMethod(json['username']),
      watchlist: ParsingHelper.parseListMethod<dynamic, int>(json['watchlist']),
      createdTime: ParsingHelper.parseTimestampMethod(json['createdTime']), // Parsed using your helper
    );
  }

  UserModel copyWith({
    String? displayName,
    String? email,
    List<int>? favorites,
    List<String>? friendRequests,
    List<String>? friends,
    String? photoUrl,
    List<String>? sentFriendRequests,
    String? uid,
    String? username,
    List<int>? watchlist,
    Timestamp? createdTime,
  }) {
    return UserModel(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      favorites: favorites ?? this.favorites,
      friendRequests: friendRequests ?? this.friendRequests,
      friends: friends ?? this.friends,
      photoUrl: photoUrl ?? this.photoUrl,
      sentFriendRequests: sentFriendRequests ?? this.sentFriendRequests,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      watchlist: watchlist ?? this.watchlist,
      createdTime: createdTime ?? this.createdTime,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'displayName': displayName,
      'email': email,
      'favorites': favorites,
      'friendRequests': friendRequests,
      'friends': friends,
      'photoUrl': photoUrl,
      'sentFriendRequests': sentFriendRequests,
      'uid': uid,
      'username': username,
      'watchlist': watchlist,
      'createdTime': createdTime, // Included in JSON output
    };
  }
}