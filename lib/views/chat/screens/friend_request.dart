import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/chat/chat_controller.dart';
import '../../../models/user_model/user_model.dart';

class FriendRequestsScreen extends StatefulWidget {
  static const String routeName = "/friendRequestScreen";

  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  late ChatController _chatController;
  late String _myUid;
  late String _myUsername;
  List<UserModel> _requests = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthenticationProvider>();
    _myUid = auth.userId.get();
    _myUsername = auth.userModel.get()?.username ?? '';
    _chatController = ChatController(chatProvider: null);
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    isLoading = true;
    setState(() {});
    final users = await _chatController.fetchFriendRequests(_myUid);
    setState(() => _requests = users);
    isLoading = false;
    setState(() {});
  }

  Future<void> _accept(UserModel user) async {
    await _chatController.acceptFriendRequest(currentUid: _myUid, requesterUid: user.uid, requesterUsername: user.username ?? '');
    _loadRequests();
  }

  Future<void> _reject(UserModel user) async {
    await _chatController.rejectFriendRequest(_myUid, user.uid);
    _loadRequests();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text("Friend Requests"),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              onPressed: () async {
                await _loadRequests();
              },
              icon: Icon(Icons.refresh),
            ),
          ],
        ),
        body:
            _requests.isEmpty
                ? const Center(child: Text("No Friend Requests", style: TextStyle(color: Colors.white)))
                : ListView.builder(
                  itemCount: _requests.length,
                  itemBuilder: (_, i) {
                    final user = _requests[i];
                    return ListTile(
                      title: Text(user.displayName ?? '', style: const TextStyle(color: Colors.white)),
                      subtitle: Text(user.email ?? '', style: const TextStyle(color: Colors.white60)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.check, color: Colors.green), onPressed: () => _accept(user)),
                          IconButton(icon: const Icon(Icons.close, color: Colors.red), onPressed: () => _reject(user)),
                        ],
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
