import 'package:flutter/material.dart';
import 'package:moviesapp/utils/my_print.dart';
import 'package:provider/provider.dart';

import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/chat/chat_controller.dart';

class FriendSuggestionsScreen extends StatefulWidget {
  static const String routeName = "/friendSuggestionScreen";
  const FriendSuggestionsScreen({super.key});

  @override
  State<FriendSuggestionsScreen> createState() => _FriendSuggestionsScreenState();
}

class _FriendSuggestionsScreenState extends State<FriendSuggestionsScreen> {
  late ChatController _chatController;
  List<Map<String, dynamic>> _suggestions = [];
  late String _fromUserId;
  late String _userName;
  List _favorites = [], _watchlist = [];
  List<String> _friends = [], _sent = [];
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthenticationProvider>();
    final user = auth.userModel.get();
    _fromUserId = user?.uid ?? '';
    _userName = user?.username ?? '';
    MyPrint.printOnConsole("User ${user?.toJson()}");

    _favorites = user?.favorites ?? [];
    _watchlist = user?.watchlist ?? [];
    _friends = user?.friends ?? [];
    _sent = user?.sentFriendRequests ?? [];
    _chatController = ChatController(chatProvider: null);
    _loadSuggestions();
  }

  Future<void> _loadSuggestions() async {
    final data = await _chatController.getFriendSuggestions(
      username: _userName,
      favorites: _favorites,
      watchlist: _watchlist,
      friends: _friends,
      sentRequests: _sent,
    );
    setState(() => _suggestions = data);
  }

  Future<void> _sendRequest(String toUsername) async {
    MyPrint.printOnConsole("FromUserName: $_fromUserId toUserName: $toUsername");
    await _chatController.sendFriendRequest(_fromUserId, toUsername);
    _loadSuggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text("Friend Suggestions"), backgroundColor: Colors.black),
      body: ListView.builder(
        itemCount: _suggestions.length,
        itemBuilder: (_, i) {
          final s = _suggestions[i];
          MyPrint.printOnConsole("ss $s");
          final toUserId = s["uid"];
          return ListTile(
            title: Text(s['displayName'] ?? '', style: const TextStyle(color: Colors.white)),
            subtitle: Text('@${s['username']}', style: const TextStyle(color: Colors.white54)),
            trailing: ElevatedButton(
              onPressed: () => _sendRequest(toUserId),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD24DFF)),
              child: const Text("Add",style: TextStyle(color: Colors.white),),
            ),
          );
        },
      ),
    );
  }
}
