import 'package:circle/app.dart';
import 'package:circle/components/google_user_circle_avatar.dart';
import 'package:circle/model/model.dart';
import 'package:circle/util.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ContactListPage extends StatefulWidget {
  const ContactListPage({Key? key}) : super(key: key);

  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  bool search = false;
  final TextEditingController _filter = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: search || _filter.text.isNotEmpty
            ? Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    setState(() {
                      search = false;
                    });
                  }
                },
                child: TextField(
                  autofocus: true,
                  controller: _filter,
                  decoration: InputDecoration(
                    hintText: 'Cari kontak',
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              )
            : Text('Daftar Kontak'),
        actions: [
          if (!search && !_filter.text.isNotEmpty)
            IconButton(
              onPressed: () {
                setState(() {
                  // search = !search;
                  search = !search;
                });
              },
              icon: Icon(Icons.search),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(kStartNewChatPage);
        },
        child: Icon(Icons.add),
      ),
      body: context.model.contacts.build((context, value) {
        final contacts = value;
        if (contacts.isEmpty) {
          return Center(
            child: Text('Tidak ada kontak'),
          );
        }
        return ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            if (search && _filter.text.isNotEmpty) {
              if (!contact.displayName
                  .toLowerCase()
                  .contains(_filter.text.toLowerCase())) {
                return Container();
              }
            }
            return ListTile(
              title: Text(contact.displayName),
              subtitle: Text(contact.email),
              leading: GoogleUserCircleAvatar(identity: contact),
              onTap: () async {
                var id = await context.model.createChat(contact.email);
                context.pushReplacementNamed(kChatPage, queryParameters: {
                  'id': id,
                });
              },
            );
          },
        );
      }),
    );
  }
}
