import 'package:circle/components/google_user_circle_avatar.dart';
import 'package:circle/model/model.dart';
import 'package:circle/util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../app.dart';
import '../components/dynamic_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 32),
          children: [
            ListTile(
              title: Text(context.self.displayName),
              leading: GoogleUserCircleAvatar(identity: context.self),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              onTap: () {
                context.pushNamed(kProfilePage, queryParameters: {
                  'id': context.self.id,
                });
              },
            ),
            const Divider(),
            ListTile(
              title: Text('Status Gempa'),
              leading: Icon(Icons.warning),
              onTap: () {
                context.pushNamed(kStatusGempaPage);
              },
            ),
            // divider
            ListTile(
              title: Text('Keluar'),
              leading: Icon(Icons.logout),
              onTap: () {
                context.model.signOut();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(kContactListPage);
        },
        child: Icon(Icons.chat),
      ),
      appBar: AppBar(
        title: Text('Circle'),
      ),
      body: context.model.chats.build((context, value) {
        print('Building chats ${value.length}');
        return ListView(
          children: value.map((chat) {
            return chat.chats.chats.build((context, chats) {
              if (chats.isEmpty) {
                return Container();
              }
              return ListTile(
                // title: Text(chat.title ?? chat.target.displayName),
                title: DynamicText(
                    value: chat.title,
                    formatter: (value) {
                      return value ?? chat.target.displayName;
                    }),
                subtitle: Text(chats.firstOrNull?.text ?? ''),
                leading: GoogleUserCircleAvatar(identity: chat.target),
                trailing: PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text('Hapus Chat'),
                        value: 'delete',
                      ),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 'delete') {
                      context.model.deleteChat(chat);
                    }
                  },
                ),
                onTap: () {
                  context.pushNamed(kChatPage, queryParameters: {
                    'id': chat.id,
                  });
                },
              );
            });
          }).toList(),
        );
      }),
    );
  }
}
