import 'package:circle/client_app.dart';
import 'package:circle/page/login_page.dart';
import 'package:circle/util.dart';
import 'package:flutter/material.dart';

class StandardPage extends StatefulWidget {
  final Widget child;

  const StandardPage({Key? key, required this.child}) : super(key: key);

  @override
  _StandardPageState createState() => _StandardPageState();
}

class _StandardPageState extends State<StandardPage> {
  @override
  Widget build(BuildContext context) {
    return context.app.user.build((context, user) {
      if (user == null) {
        return const LoginPage();
      }
      return widget.child;
    });
  }
}
