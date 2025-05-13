import 'package:flutter/material.dart';
import 'package:moviesapp/backend/navigation/navigation_arguments.dart';
import 'package:moviesapp/backend/navigation/navigation_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_operation_parameters.dart';
import 'package:moviesapp/backend/navigation/navigation_type.dart';
import 'package:moviesapp/utils/my_print.dart';
import 'package:provider/provider.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/user/user_repository.dart';
import '../../../models/user_model/user_model.dart';

class MainChatScreen extends StatelessWidget {
  const MainChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userModel = context
        .read<AuthenticationProvider>()
        .userModel
        .get();
    MyPrint.printOnConsole("UserModel : ${userModel?.friends}");

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Chats', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black87],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.person_add_alt_1, color: Color(0xFFD24DFF)),
                  onPressed: () {
                    NavigationController.navigateToFriendSuggestionScreen(
                      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Color(0xFFD24DFF)),
                  onPressed: () {
                    NavigationController.navigateToFriendRequestScreen(
                      navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _getFriends(userModel);
        },
        child: FutureBuilder<List<UserModel>>(
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
                return GestureDetector(
                  onTap: () {
                    NavigationController.navigateToChatScreen(
                      navigationOperationParameters: NavigationOperationParameters(
                        context: context,
                        navigationType: NavigationType.pushNamed,
                      ),
                      arguments: ChatScreenArguments(
                        
                        receiverId: friend.uid,
                        receiverName: friend.displayName ?? '',
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFFD24DFF).withOpacity(0.2),
                          child: Text(
                            (friend.displayName?.isNotEmpty ?? false)
                                ? friend.displayName![0].toUpperCase()
                                : '?',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                friend.displayName ?? '',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                friend.email ?? '',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFD24DFF), size: 18),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
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
      MyPrint.printOnConsole("_getFriends(userModel) : ${currentUser.toJson()}");
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
