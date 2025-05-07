import 'package:flutter/material.dart';
import 'package:moviesapp/utils/my_print.dart';
import 'package:provider/provider.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/user/user_repository.dart';
import '../../../models/user_model/user_model.dart';

class MainChatScreen extends StatelessWidget {
  const MainChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = context.read<AuthenticationProvider>().userModel.get();
    MyPrint.printOnConsole("UserModel : ${userModel?.friends}");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('CHAT', style: TextStyle(color: Colors.white, fontSize: 28)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Color(0xFFD24DFF)),
            onPressed: () {
              Navigator.pushNamed(context, '/friendSuggestions');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Color(0xFFD24DFF)),
            onPressed: () {
              Navigator.pushNamed(context, '/friendRequests');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _getFriends(userModel),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFD24DFF)));
          }

          final friends = snapshot.data!;
          if (friends.isEmpty) {
            return const Center(
              child: Text("No Friends", style: TextStyle(color: Colors.white, fontSize: 20)),
            );
          }

          return ListView.builder(
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friend = friends[index];
              return ListTile(
                title: Text(friend.displayName ?? "", style: const TextStyle(color: Colors.white)),
                subtitle: Text(friend.email ?? "", style: const TextStyle(color: Colors.white54)),
                trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFD24DFF)),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/chatScreen',
                    arguments: {
                      'receiverId': friend.uid,
                      'receiverName': friend.displayName,
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }


  Future<List<UserModel>> _getFriends(UserModel? currentUser) async {
    if (currentUser == null || currentUser.uid.isEmpty) return [];

    List<UserModel> friends = [];
    UserRepository userRepository = UserRepository();

    try {
      // Assuming the currentUser.friends is a List<String> of UIDs
      List<String> friendUids = currentUser.friends ?? [];

      for (String uid in friendUids) {
        UserModel? user = await userRepository.getUserModelFromId(userId: uid);
        if (user != null) {
          friends.add(user);
        }
      }
    } catch (e) {
      debugPrint('Error fetching friends: $e');
    }

    return friends;
  }

}
