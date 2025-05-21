import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model/user_model.dart';
import '../../utils/my_print.dart';

class ChatRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getChatsStream(String uid1, String uid2) {
    try {
      return _firestore
          .collection('messages')
          .where('sender_id', whereIn: [uid1, uid2])
          .where('receiver_id', whereIn: [uid1, uid2])
          .orderBy('timeStamp')
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()!}).toList());
    } catch (e) {
      MyPrint.printOnConsole("Error in getChatsStream: $e");
      return const Stream.empty();
    }
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      await _firestore.collection("messages").add({
        '_id': DateTime.now().millisecondsSinceEpoch.toString(),
        'timeStamp': DateTime.now().toIso8601String(),
        'sender_id': senderId,
        'receiver_id': receiverId,
        'data': message,
      });
    } catch (e) {
      MyPrint.printOnConsole("Error sending message: $e");
    }
  }

  Future<List<UserModel>> getFriendRequests(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('user').doc(uid).get();
      List<String> requestUids = List<String>.from(docSnapshot.data()?['friendRequests'] ?? []);
      List<UserModel> users = [];

      for (String requesterUid in requestUids) {
        final q = await _firestore.collection("user").where("uid", isEqualTo: requesterUid).get();
        if (q.docs.isNotEmpty) {
          users.add(UserModel.fromJson(q.docs.first.data()));
        }
      }

      return users;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> acceptFriendRequest({
    required String currentUid,
    required String requesterUid,
    required String requesterUsername,
  }) async {
    final batch = _firestore.batch();
    final currentRef = _firestore.collection('user').doc(currentUid);
    final requesterRef = _firestore.collection('user').doc(requesterUid);

    batch.update(currentRef, {
      'friends': FieldValue.arrayUnion([requesterUid]),
      'friendRequests': FieldValue.arrayRemove([requesterUid]),
    });

    batch.update(requesterRef, {
      'friends': FieldValue.arrayUnion([currentUid]),
      'sentFriendRequests': FieldValue.arrayRemove([currentUid]),
    });

    await batch.commit();
  }

  Future<void> rejectFriendRequest(String currentUid, String requesterUid) async {
    await _firestore.collection('user').doc(currentUid).update({
      'friendRequests': FieldValue.arrayRemove([requesterUid])
    });
  }

  Future<List<Map<String, dynamic>>> suggestFriends({
    required String username,
    required List favorites,
    required List watchlist,
    required List<String> sentRequests,
    required List<String> friends,
  }) async {
    final snapshot = await _firestore
        .collection('user')
        .where("username", isNotEqualTo: username)
        .get();

    List<Map<String, dynamic>> suggestions = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final docUsername = doc.id;
      //
      // if (friends.contains(docUsername) || sentRequests.contains(docUsername)) {
      //   // Debug
      //   print('Skipping friend/sent: $docUsername');
      //   continue;
      // }

      // final favScore = _matchScore(List.from(data['favorites'] ?? []), favorites);
      // final watchScore = _matchScore(List.from(data['watchlist'] ?? []), watchlist);
      // final score = favScore + watchScore;

      suggestions.add({...data, 'username': docUsername,});
    }

    // suggestions.sort((a, b) => (b['score']).compareTo(a['score']));
    return suggestions.take(10).toList();
  }

  double _matchScore(List listA, List listB) {
    return listA.where((item) => listB.contains(item)).length.toDouble();
  }

  Future<void> sendFriendRequest(String senderUsername, String receiverUsername) async {
    final senderRef = _firestore.collection('user').doc(senderUsername);
    final receiverRef = _firestore.collection('user').doc(receiverUsername);

    await senderRef.update({
      'sentFriendRequests': FieldValue.arrayUnion([receiverUsername])
    });

    await receiverRef.update({
      'friendRequests': FieldValue.arrayUnion([senderUsername])
    });
  }

  Future<void> unfriendUser(String fromUserId, String toUserId) async {
    // Make actual backend call or Firebase Firestore update here
    await FirebaseFirestore.instance.collection('user').doc(fromUserId).update({
      'friends': FieldValue.arrayRemove([toUserId])
    });

    await FirebaseFirestore.instance.collection('user').doc(toUserId).update({
      'friends': FieldValue.arrayRemove([fromUserId])
    });
  }
}
