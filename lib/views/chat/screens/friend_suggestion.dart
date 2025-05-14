import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:moviesapp/backend/user/user_controller.dart';
import 'package:moviesapp/models/user_model/user_model.dart';
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
  late AuthenticationProvider authenticationProvider;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    authenticationProvider = context.read<AuthenticationProvider>();
    final user = authenticationProvider.userModel.get();
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
    isLoading = true;
    setState(() {
    });
    MyPrint.printOnConsole("FromUserName: $_fromUserId toUserName: $_userName");

    final data = await _chatController.getFriendSuggestions(
      username: _userName,
      favorites: _favorites,
      watchlist: _watchlist,
      friends: _friends,
      sentRequests: _sent,
    );
    MyPrint.printOnConsole("data: ${data} ${_sent}");
    setState(() => _suggestions = data);
    isLoading = false;
    setState(() {
    });
  }

  Future<void> _sendRequest(String toUsername) async {
    MyPrint.printOnConsole("FromUserName: $_fromUserId toUserName: $toUsername");
    await _chatController.sendFriendRequest(_fromUserId, toUsername);
    await _loadSuggestions();
    _sent.addAll([toUsername]);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,

      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Friend Suggestions"),
          backgroundColor: Colors.black,
          actions: [IconButton(onPressed: () async {
            await _loadSuggestions();
          }, icon: Icon(Icons.refresh))],
        ),
        body: ListView.builder(
          itemCount: _suggestions.length,
          itemBuilder: (_, i) {
            final s = _suggestions[i];
            MyPrint.printOnConsole("ss ${s["userName"]}");
            final toUserId = s["uid"];
            return ListTile(
              title: Text(s['displayName'] ?? '', style: const TextStyle(color: Colors.white)),
              subtitle: Text('@${s['displayName']}', style: const TextStyle(color: Colors.white54)),
              trailing: Builder(
                builder: (_) {
                  final toUsername = s['uid'];
                  final isSent = _sent.contains(toUsername);
                  MyPrint.printOnConsole("isSent : ${isSent}");
                  final isFriend = _friends.contains(toUsername);

                  if (isFriend) {
                    return ElevatedButton(
                      // onPressed: () => _unfriend(toUsername),
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text("Unfriend", style: TextStyle(color: Colors.white)),
                    );
                  } else if (isSent) {
                    return ElevatedButton(
                      onPressed: null, // or show Undo logic
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      child: const Text("Request Sent", style: TextStyle(color: Colors.white)),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () => _sendRequest(toUsername),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD24DFF)),
                      child: const Text("Add", style: TextStyle(color: Colors.white)),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
