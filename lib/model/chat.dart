import 'package:circle/model/user.dart';
import 'package:circle/storage/chat_storage.dart';
import 'package:flutter/cupertino.dart';

class Chat {
  final String id;
  ValueNotifier<String?> title;

  final User target;
  final ChatStorage chats;

  Chat({
    required this.id,
    required this.title,
    required this.target,
    required this.chats,
  });
}
