import 'package:circle/app.dart';
import 'package:circle/model/model.dart';
import 'package:circle/util.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartNewChatPage extends StatefulWidget {
  const StartNewChatPage({Key? key}) : super(key: key);

  @override
  _StartNewChatPageState createState() => _StartNewChatPageState();
}

class _StartNewChatPageState extends State<StartNewChatPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
          vertical: 54,
          horizontal: 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headlineLarge(Text('Mulai Chat Baru')),
            const SizedBox(height: 16),
            Text('Masukkan email teman yang ingin kamu ajak chat'),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('Start new chat with ${_emailController.text}');
                // validate email
                if (EmailValidator.validate(_emailController.text)) {
                  // prevent chat to self
                  if (_emailController.text == context.self.email) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Tidak bisa chat dengan diri sendiri'),
                          content: Text(
                              'Kamu tidak bisa chat dengan diri sendiri. Silahkan coba lagi.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                  print('Email valid');
                  // check if theres a chat with this email
                  // if yes, go to chat page
                  // if no, create new chat
                  print('Chat with ${_emailController.text} does not exist');
                  context.model
                      .createChat(_emailController.text)
                      .then((chatId) {
                    if (chatId == null) {
                      // the user is not registered within the app
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('User tidak ditemukan'),
                            content: Text(
                                'User dengan email ${_emailController.text} tidak ditemukan. Silahkan coba lagi.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      context.pushNamed(kChatPage, queryParameters: {
                        'id': chatId,
                      });
                    }
                  });
                } else {
                  print('Email invalid');
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Email tidak valid'),
                        content: Text(
                            'Email yang kamu masukkan tidak valid. Silahkan coba lagi.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Mulai Chat'),
            ),
          ],
        ),
      ),
    );
  }
}
