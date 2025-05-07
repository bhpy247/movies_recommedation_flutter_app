import 'package:flutter/material.dart';
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
}
