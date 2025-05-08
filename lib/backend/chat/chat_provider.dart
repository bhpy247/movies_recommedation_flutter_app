import '../../models/user_model/user_model.dart';
import '../common/common_provider.dart';

class ChatProvider extends CommonProvider {
  ChatProvider() {
    messages = CommonProviderPrimitiveParameter<List<Map<String, dynamic>>>(
      value: [],
      notify: notify,
    );
    isLoading = CommonProviderPrimitiveParameter<bool>(
      value: false,
      notify: notify,
    );
    friendRequests = CommonProviderPrimitiveParameter<List<UserModel>>(
      value: [],
      notify: notify,
    );

    suggestions = CommonProviderPrimitiveParameter<List<Map<String, dynamic>>>(
      value: [],
      notify: notify,
    );
  }

  late CommonProviderPrimitiveParameter<List<Map<String, dynamic>>> messages;
  late CommonProviderPrimitiveParameter<bool> isLoading;

  late CommonProviderPrimitiveParameter<List<UserModel>> friendRequests;
  late CommonProviderPrimitiveParameter<List<Map<String, dynamic>>> suggestions;


  void setMessages(List<Map<String, dynamic>> newMessages, {bool isNotify = true}) {
    messages.set(value: newMessages, isNotify: isNotify);
  }

  void addMessage(Map<String, dynamic> message, {bool isNotify = true}) {
    final updateMessage = [...messages.get(), message];
    messages.set(value: updateMessage, isNotify: isNotify);
  }

  void setLoading(bool value, {bool isNotify = true}) {
    isLoading.set(value: value, isNotify: isNotify);
  }

  void resetData({bool isNotify = true}) {
    messages.set(value: [], isNotify: isNotify);
    isLoading.set(value: false, isNotify: isNotify);
  }



  void setFriendRequests(List<UserModel> list, {bool isNotify = true}) {
  friendRequests.set(value: list, isNotify: isNotify);
  }

  void setSuggestions(List<Map<String, dynamic>> list, {bool isNotify = true}) {
  suggestions.set(value: list, isNotify: isNotify);
  }

}
