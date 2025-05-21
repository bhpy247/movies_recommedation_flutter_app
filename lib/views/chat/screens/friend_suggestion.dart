import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:moviesapp/backend/authentication/authentication_controller.dart';
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
  final TextEditingController _search = TextEditingController();
  late final AuthenticationProvider _authProvider;
  late final AuthenticationController _authController;
  late final ChatController _chatController;

  UserModel? _currentUser;
  List<Map<String, dynamic>> _suggestions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _authProvider = context.read<AuthenticationProvider>();
    _authController = AuthenticationController(authenticationProvider: _authProvider);
    _chatController = ChatController(chatProvider: null);
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);

    try {
      // Fetch latest user model
      final userId = _authProvider.userId.get();
      await _authController.getUserModel(userId: userId);

      final user = _authProvider.userModel.get();
      if (user == null) throw Exception("User not found");

      _currentUser = user;

      final suggestions = await _chatController.getFriendSuggestions(
        username: user.username ?? '',
        favorites: user.favorites ?? [],
        watchlist: user.watchlist ?? [],
        friends: user.friends ?? [],
        sentRequests: user.sentFriendRequests ?? [],
      );

      _suggestions = suggestions;
    } catch (e) {
      debugPrint("Error loading suggestions: $e");
    }

    setState(() => _isLoading = false);
  }

  Future<void> _sendRequest(String toUserId) async {
    if (_currentUser == null) return;

    try {
      await _chatController.sendFriendRequest(_currentUser!.uid, toUserId);
      await _fetchData();
    } catch (e) {
      debugPrint("Send request error: $e");
    }
  }

  Future<void> _unfriend(String toUserId) async {
    if (_currentUser == null) return;

    try {
      await _chatController.unfriendUser(_currentUser!.uid, toUserId);
      await _fetchData();
    } catch (e) {
      debugPrint("Unfriend error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to unfriend. Please try again.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Friend Suggestions"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFD24DFF)))
          : _suggestions.isEmpty
          ? const Center(
        child: Text(
          "No suggestions found",
          style: TextStyle(color: Colors.white),
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchData,
        child: ListView.builder(
          itemCount: _suggestions.length,
          itemBuilder: (_, index) {
            final s = _suggestions[index];
            final toUserId = s["uid"];
            final displayName = s["displayName"] ?? "";

            final isFriend = _currentUser?.friends?.contains(toUserId) ?? false;
            final isSent = _currentUser?.sentFriendRequests?.contains(toUserId) ?? false;

            return ListTile(
              title: Text(
                displayName,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text('@$displayName', style: const TextStyle(color: Colors.white54)),
              trailing: isFriend
                  ? ElevatedButton(
                onPressed: () => _unfriend(toUserId),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Unfriend", style: TextStyle(color: Colors.white)),
              )
                  : isSent
                  ? ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                child: const Text("Request Sent", style: TextStyle(color: Colors.white)),
              )
                  : ElevatedButton(
                onPressed: () => _sendRequest(toUserId),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD24DFF)),
                child: const Text("Add", style: TextStyle(color: Colors.white)),
              ),
            );
          },
        ),
      ),
    );
  }
}

