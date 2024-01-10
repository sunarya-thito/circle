import 'package:circle/model/user.dart';

class ChatMessage {
  final String id;
  final User sender;
  String text;
  bool edited;
  final DateTime sentAt;
  bool seen;
  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.sentAt,
    required this.edited,
    required this.seen,
  });
}
