import 'package:cloud_firestore/cloud_firestore.dart';
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
}
