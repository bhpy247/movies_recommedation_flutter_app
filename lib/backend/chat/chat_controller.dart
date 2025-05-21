import 'package:flutter/material.dart';
import 'package:moviesapp/utils/my_print.dart';
import '../../models/user_model/user_model.dart';
import 'chat_provider.dart';
import 'chat_repository.dart';

class ChatController {
  late ChatProvider _chatProvider;
  late ChatRepository _chatRepository;

  ChatController({required ChatProvider? chatProvider, ChatRepository? repository}) {
    _chatProvider = chatProvider ?? ChatProvider();
    _chatRepository = repository ?? ChatRepository();
  }

  ChatProvider get chatProvider => _chatProvider;
  ChatRepository get chatRepository => _chatRepository;

  void listenToChats(String uid1, String uid2) {
    chatProvider.setLoading(true);
    _chatRepository.getChatsStream(uid1, uid2).listen((messages) {
      chatProvider.setMessages(messages);
      chatProvider.setLoading(false);
    });
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    await _chatRepository.sendMessage(
      senderId: senderId,
      receiverId: receiverId,
      message: message,
    );
  }

  void reset() {
    chatProvider.resetData();
  }

  Future<List<UserModel>> fetchFriendRequests(String uid) async {
    return await _chatRepository.getFriendRequests(uid);
  }

  Future<void> acceptFriendRequest({
    required String currentUid,
    required String requesterUid,
    required String requesterUsername,
  }) async {
    await _chatRepository.acceptFriendRequest(
      currentUid: currentUid,
      requesterUid: requesterUid,
      requesterUsername: requesterUsername,
    );
  }

  Future<void> rejectFriendRequest(String currentUid, String requesterUid) async {
    await _chatRepository.rejectFriendRequest(currentUid, requesterUid);
  }

  Future<List<Map<String, dynamic>>> getFriendSuggestions({
    required String username,
    required List favorites,
    required List watchlist,
    required List<String> sentRequests,
    required List<String> friends,
  }) async {
    MyPrint.printOnConsole("UserName : ${username}");
    return await _chatRepository.suggestFriends(
      username: username,
      favorites: favorites,
      watchlist: watchlist,
      sentRequests: sentRequests,
      friends: friends,
    );
  }

  Future<void> sendFriendRequest(String fromUsername, String toUsername) async {
    await _chatRepository.sendFriendRequest(fromUsername, toUsername);
  }
  Future<void> unfriendUser(String fromUserId, String toUserId) async {
    await _chatRepository.unfriendUser(fromUserId, toUserId);
  }
}
