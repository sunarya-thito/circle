import 'package:circle/model/chat_message.dart';
import 'package:circle/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatStorage {
  final CollectionReference<Map<String, dynamic>> collection;
  final ValueNotifier<List<ChatMessage>> chats = ValueNotifier([]);

  ChatStorage({
    required this.collection,
  }) {
    collection.snapshots().listen((event) {
      List<ChatMessage> copy = [];
      for (var doc in event.docs) {
        ChatMessage? existing =
            chats.value.where((element) => element.id == doc.id).firstOrNull;
        if (existing != null) {
          copy.add(existing);
          existing.text = doc.data()['text'];
          continue;
        }

        copy.add(
          ChatMessage(
            id: doc.id,
            sender: User(
              id: doc.data()['sender']['id'],
              displayName: doc.data()['sender']['displayName'],
              email: doc.data()['sender']['email'],
              photoURL: doc.data()['sender']['photoURL'],
            ),
            text: doc.data()['text'],
            sentAt: DateTime.parse(doc.data()['sentAt']),
            edited: false,
            seen: false,
          ),
        );
      }
      // sort
      copy.sort((a, b) => b.sentAt.compareTo(a.sentAt));
      chats.value = copy;
    });
  }

  void dispose() {
    chats.dispose();
  } // returns false, is has no more chats
}
