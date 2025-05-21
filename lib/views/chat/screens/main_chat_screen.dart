import 'package:flutter/material.dart';
import 'package:moviesapp/backend/authentication/authentication_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_arguments.dart';
import 'package:moviesapp/backend/navigation/navigation_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_operation_parameters.dart';
import 'package:moviesapp/backend/navigation/navigation_type.dart';
import 'package:moviesapp/utils/my_print.dart';
import 'package:provider/provider.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/user/user_repository.dart';
import '../../../models/user_model/user_model.dart';

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  late UserModel? _userModel;
  List<UserModel> _friends = [];
  bool _isLoading = false;
  late AuthenticationProvider authenticationProvider;

  @override
  void initState() {
    super.initState();
    authenticationProvider = context.read<AuthenticationProvider>();

    _loadFriends();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);

    try {
      // Fetch latest user model
      final userId = authenticationProvider.userId.get();
      await AuthenticationController(authenticationProvider: authenticationProvider).getUserModel(userId: userId);

      final user = authenticationProvider.userModel.get();
      if (user == null) throw Exception("User not found");
    } catch (e) {
      debugPrint("Error loading suggestions: $e");
    }

    setState(() => _isLoading = false);
  }

  Future<void> _loadFriends() async {
    _userModel = context.read<AuthenticationProvider>().userModel.get();
    if (_userModel == null || _userModel!.uid.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final friendUids = _userModel?.friends ?? [];
      final repo = UserRepository();
      final futures = friendUids.map((uid) => repo.getUserModelFromId(userId: uid));
      final results = await Future.wait(futures);

      _friends = results.whereType<UserModel>().toList();
    } catch (e) {
      debugPrint('Error fetching friends: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    MyPrint.printOnConsole("Friends: ${_userModel?.friends}");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('CHAT', style: TextStyle(color: Colors.white, fontSize: 28)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFD24DFF)),
            onPressed: _loadFriends,
          ),
          IconButton(
            icon: const Icon(Icons.person_add, color: Color(0xFFD24DFF)),
            onPressed: () async {
             await NavigationController.navigateToFriendSuggestionScreen(
                navigationOperationParameters: NavigationOperationParameters(
                  context: context,
                  navigationType: NavigationType.pushNamed,
                ),
              );
            await _loadFriends();
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFFD24DFF)),
            onPressed: () async {
              await NavigationController.navigateToFriendRequestScreen(
                navigationOperationParameters: NavigationOperationParameters(
                  context: context,
                  navigationType: NavigationType.pushNamed,
                ),
              );
              await _fetchData();
              await _loadFriends();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadFriends,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFFD24DFF)))
            : _friends.isEmpty
            ? const Center(
          child: Text(
            "No Friends",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
            : ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: _friends.length,
          separatorBuilder: (_, __) => const Divider(color: Colors.white10),
          itemBuilder: (context, index) {
            final friend = _friends[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                friend.displayName ?? "",
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                friend.email ?? "",
                style: const TextStyle(color: Colors.white54),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFD24DFF)),
              onTap: () {
                NavigationController.navigateToChatScreen(
                  navigationOperationParameters: NavigationOperationParameters(
                    context: context,
                    navigationType: NavigationType.pushNamed,
                  ),
                  arguments: ChatScreenArguments(
                    receiverId: friend.uid,
                    receiverName: friend.displayName,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

