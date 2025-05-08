import 'package:flutter/material.dart';
import 'package:moviesapp/backend/navigation/navigation_arguments.dart';
import 'package:moviesapp/backend/navigation/navigation_controller.dart';
import 'package:moviesapp/backend/navigation/navigation_operation_parameters.dart';
import 'package:moviesapp/backend/navigation/navigation_type.dart';
import 'package:provider/provider.dart';
import '../../../backend/authentication/authentication_provider.dart';
import '../../../backend/chat/chat_controller.dart';
import '../../../backend/chat/chat_provider.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = "/chatScreen";
  ChatScreenArguments arguments;

  ChatScreen({super.key, required this.arguments});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late ChatController _chatController;
  late String _myId;
  late String receiverId, receiverName;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthenticationProvider>();
    _myId = authProvider.userId.get();
    final chatProvider = context.read<ChatProvider>();
    receiverId = widget.arguments.receiverId;
    receiverName = widget.arguments.receiverName;
    _chatController = ChatController(chatProvider: chatProvider);
    _chatController.listenToChats(_myId, receiverId);
  }

  void _sendMessage() async {
    final msg = _controller.text.trim();
    if (msg.isEmpty) return;

    await _chatController.sendMessage(senderId: _myId, receiverId: receiverId, message: msg);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messages = context.watch<ChatProvider>().messages.get();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(receiverName, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed:
                () => NavigationController.navigateToFriendRequestScreen(
                  navigationOperationParameters: NavigationOperationParameters(context: context, navigationType: NavigationType.pushNamed),
                ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg['sender_id'] == _myId;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(color: isMe ? const Color(0xFFD24DFF) : Colors.grey[800], borderRadius: BorderRadius.circular(10)),
                    child: Text(msg['data'], style: const TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
          ),
          Container(
            color: const Color(0xFF353535),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(hintText: 'Type Here...', hintStyle: TextStyle(color: Colors.grey), border: InputBorder.none),
                  ),
                ),
                IconButton(icon: const Icon(Icons.send, color: Color(0xFFD24DFF)), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
