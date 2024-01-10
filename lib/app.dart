import 'package:circle/client_app.dart';
import 'package:circle/components/data_widget.dart';
import 'package:circle/components/standard_page.dart';
import 'package:circle/model/chat.dart';
import 'package:circle/model/model.dart';
import 'package:circle/page/chat_page.dart';
import 'package:circle/page/contact_list_page.dart';
import 'package:circle/page/home_page.dart';
import 'package:circle/page/not_found_page.dart';
import 'package:circle/page/profile_page.dart';
import 'package:circle/page/start_new_chat.dart';
import 'package:circle/page/status_gempa_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const kHomePage = 'home';
const kChatPage = 'chat';
const kProfilePage = 'profile';
const kStartNewChatPage = 'start_new_chat';
const kContactListPage = 'contacts';
const kNotFoundPage = 'not_found';
const kStatusGempaPage = 'status_gempa';

class App extends StatelessWidget {
  final GoRouter _router = GoRouter(routes: [
    GoRoute(
      path: '/',
      name: kHomePage,
      builder: (context, state) => HomePage(),
    ),
    GoRoute(
      path: '/status_gempa',
      name: kStatusGempaPage,
      builder: (context, state) => StatusGempaPage(),
    ),
    GoRoute(
        path: '/chat',
        name: kChatPage,
        builder: (context, state) {
          final id = state.uri.queryParameters['id'];
          print('Chat ID: $id');
          if (id == null) {
            return NotFoundPage();
          }
          Chat? chat = context.model.chats.value
              .where((element) => element.id == id)
              .firstOrNull;
          print('Chat: $chat ${context.model.chats.value.map((e) => e.id)}');
          if (chat == null) {
            return NotFoundPage();
          }
          return ChatPage(
            chat: chat,
          );
        }),
    GoRoute(
        path: '/profile',
        name: kProfilePage,
        builder: (context, state) {
          final id = state.uri.queryParameters['id'];
          if (id == null) {
            return NotFoundPage();
          }
          return ProfilePage(
            userId: id,
          );
        }),
    GoRoute(
        path: '/start_new_chat',
        name: kStartNewChatPage,
        builder: (context, state) {
          return StartNewChatPage();
        }),
    GoRoute(
      path: '/contacts',
      name: kContactListPage,
      builder: (context, state) => ContactListPage(),
    )
  ]);

  final ClientApp _app = ClientApp();
  late ModelRegistry _model;

  App({Key? key}) : super(key: key) {
    _model = ModelRegistry(
      user: _app.user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DataWidget(
      data: _app,
      child: DataWidget(
        data: _model,
        child: Builder(builder: (context) {
          return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: _router,
              themeMode: ThemeMode.dark,
              theme: ThemeData.dark(useMaterial3: true),
              builder: (context, child) {
                return StandardPage(child: child!);
              });
        }),
      ),
    );
  }
}
