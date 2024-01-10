import 'package:circle/components/dynamic_text.dart';
import 'package:circle/components/google_user_circle_avatar.dart';
import 'package:circle/model/model.dart';
import 'package:circle/model/user.dart';
import 'package:circle/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as chat_ui;

import '../model/chat.dart';

class ChatPage extends StatefulWidget {
  final Chat chat;

  const ChatPage({Key? key, required this.chat}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.chat.title ?? widget.chat.target.displayName),
        title: DynamicText(
            value: widget.chat.title,
            formatter: (value) {
              return value ?? widget.chat.target.displayName;
            }),
        actions: [
          // edit chat title
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final _controller = TextEditingController();
                  return AlertDialog(
                    title: Text('Edit nama chat'),
                    content: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Nama chat',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            String? result = _controller.text.isEmpty
                                ? null
                                : _controller.text;
                            context.model.editChatTitle(
                              widget.chat,
                              result,
                            );
                            widget.chat.title.value =
                                result ?? widget.chat.target.displayName;
                            print('Edit chat title to ${_controller.text}');
                            Navigator.pop(context);
                          });
                        },
                        child: Text('Simpan'),
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: widget.chat.chats.chats.build((context, chats) {
        return chat_ui.Chat(
          theme: chat_ui.DarkChatTheme(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            inputBackgroundColor:
                Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1),
            primaryColor: Theme.of(context).colorScheme.primaryContainer,
            secondaryColor: Theme.of(context).colorScheme.secondaryContainer,
          ),
          showUserAvatars: true,
          showUserNames: true,
          messages: chats.map((chat) {
            return types.TextMessage(
              author: types.User(
                  id: chat.sender.id,
                  firstName: chat.sender.displayName,
                  imageUrl: chat.sender.photoURL),
              createdAt: chat.sentAt.millisecondsSinceEpoch,
              id: chat.id,
              text: chat.text,
            );
          }).toList(),
          onSendPressed: (text) {
            // widget.chat.chats.collection.add({
            //   'sender': {
            //     'id': context.self.id,
            //     'displayName': context.self.displayName,
            //     'email': context.self.email,
            //     'photoURL': context.self.photoURL,
            //   },
            //   'text': text.text,
            //   'sentAt': DateTime.now().toIso8601String(),
            //   'edited': false,
            //   'seen': false,
            // });
            context.model.sendMessage(widget.chat, text.text);
          },
          avatarBuilder: (author) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: 32,
                  height: 32,
                ),
                child: GoogleUserCircleAvatar(
                  identity: User(
                      id: author.id,
                      displayName: author.firstName ?? '',
                      photoURL: author.imageUrl ?? '',
                      email: ''),
                ),
              ),
            );
          },
          user: types.User(id: context.self.id),
        );
      }),
    );
  }
}
