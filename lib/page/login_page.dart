import 'package:circle/model/model.dart';
import 'package:circle/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Expanded(
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'images/circle.png',
                      width: 100,
                    ),
                    const SizedBox(height: 8),
                    titleLarge(Text(
                      'Circle',
                    )),
                  ],
                ),
              ),
            ),
            headlineLarge(Text('Login')),
            const SizedBox(height: 8),
            Text('Silahkan login untuk melanjutkan'),
            const SizedBox(height: 16),
            SignInButton(
              Buttons.GoogleDark,
              onPressed: () {
                print('Google Sign In');
                context.model.signInGoogle();
              },
            ),
          ],
        ),
      ),
    );
  }
}
