import 'package:flutter/material.dart';
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
  }

  late CommonProviderPrimitiveParameter<List<Map<String, dynamic>>> messages;
  late CommonProviderPrimitiveParameter<bool> isLoading;

  void setMessages(List<Map<String, dynamic>> newMessages, {bool isNotify = true}) {
    messages.set(value: newMessages, isNotify: isNotify);
  }

  void addMessage(Map<String, dynamic> message, {bool isNotify = true}) {
    final updated = [...messages.get() ?? [], message];
    messages.set(value: updated, isNotify: isNotify);
  }

  void setLoading(bool value, {bool isNotify = true}) {
    isLoading.set(value: value, isNotify: isNotify);
  }

  void resetData({bool isNotify = true}) {
    messages.set(value: [], isNotify: isNotify);
    isLoading.set(value: false, isNotify: isNotify);
  }
}
