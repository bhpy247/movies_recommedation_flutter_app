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
    MyPrint.printOnConsole("data: ${data} ${_sent}");
    setState(() => _suggestions = data);
  }

  Future<void> _sendRequest(String toUsername) async {
    MyPrint.printOnConsole("FromUserName: $_fromUserId toUserName: $toUsername");
    await _chatController.sendFriendRequest(_fromUserId, toUsername);
   await _loadSuggestions();
    _sent.addAll([toUsername]);
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
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFD24DFF).withOpacity(0.2),
                  child: Text(
                    (s['displayName']?.isNotEmpty ?? false) ? s['displayName'][0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s['displayName'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${s['username']}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (_) {
                    final toUsername = s['uid'];
                    final isSent = _sent.contains(toUsername);
                    final isFriend = _friends.contains(toUsername);

                    if (isFriend) {
                      return ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text("Unfriend", style: TextStyle(color: Colors.white)),
                      );
                    } else if (isSent) {
                      return ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: const Text("Request Sent", style: TextStyle(color: Colors.white)),
                      );
                    } else {
                      return ElevatedButton(
                        onPressed: () => _sendRequest(toUsername),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD24DFF),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          elevation: 6,
                          shadowColor: const Color(0xFFD24DFF).withOpacity(0.4),
                        ),
                        child: const Text("Add", style: TextStyle(color: Colors.white)),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
