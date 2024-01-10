import 'package:circle/components/data_widget.dart';
import 'package:circle/model/chat.dart';
import 'package:circle/model/user.dart';
import 'package:circle/storage/chat_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as a;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ModelRegistry {
  final ValueNotifier<User?> user;
  late FirebaseFirestore db;
  late a.FirebaseAuth auth;

  final ValueNotifier<List<Chat>> chats = ValueNotifier([]);
  final ValueNotifier<List<User>> contacts = ValueNotifier([]);

  ModelRegistry({
    required this.user,
  }) {
    _init();
  }

  void _init() {
    db = FirebaseFirestore.instance;
    auth = a.FirebaseAuth.instance;
    auth.userChanges().listen(_updateUser);
    _updateUser(auth.currentUser);
  }

  void _updateUser(a.User? user) {
    this.user.value = user == null
        ? null
        : SelfUser(
            id: user.uid,
            displayName: user.displayName ?? '?',
            email: user.email ?? '?',
            photoURL: user.photoURL,
            firebaseUser: user,
          );
    print('User: ${this.user.value}');
    if (this.user.value is SelfUser) {
      var chatList = db
          .doc('users/${this.user.value!.id}')
          .collection('chats')
          .snapshots();
      chatList.listen((event) {
        List<Chat> copy = [];
        for (var doc in event.docs) {
          Chat? existing =
              chats.value.where((element) => element.id == doc.id).firstOrNull;
          if (existing != null) {
            copy.add(existing);
            print('Existing: $existing');
            existing.title.value = doc.data()['title'];
            continue;
          }
          copy.add(
            Chat(
              id: doc.id,
              title: ValueNotifier<String?>(doc.data()['title']),
              target: User(
                id: doc.data()['target']['id'],
                displayName: doc.data()['target']['displayName'],
                email: doc.data()['target']['email'],
                photoURL: doc.data()['target']['photoURL'],
              ),
              chats: ChatStorage(
                collection: db
                    .doc('users/${this.user.value!.id}/chats/${doc.id}')
                    .collection('messages'),
              ),
            ),
          );
        }
        chats.value = copy;
      });

      var contactList = db
          .doc('users/${this.user.value!.id}')
          .collection('contacts')
          .snapshots();

      contactList.listen((event) {
        List<User> copy = [];
        for (var doc in event.docs) {
          User? existing = contacts.value
              .where((element) => element.id == doc.id)
              .firstOrNull;
          if (existing != null) {
            copy.add(existing);
            existing.displayName = doc.data()['displayName'];
            existing.email = doc.data()['email'];
            existing.photoURL = doc.data()['photoURL'];
            continue;
          }
          copy.add(
            User(
              id: doc.id,
              displayName: doc.data()['displayName'],
              email: doc.data()['email'],
              photoURL: doc.data()['photoURL'],
            ),
          );
        }
        contacts.value = copy;
      });

      // make sure that the user has a document in the users collection
      print('users/${this.user.value!.id}');
      db.doc('users/${this.user.value!.id}').set({
        'email': this.user.value!.email,
        'displayName': this.user.value!.displayName,
        'photoURL': this.user.value!.photoURL,
      }, SetOptions(merge: true));
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future<void> signInGoogle() async {
    if (kIsWeb) {
      await auth.signInWithPopup(a.GoogleAuthProvider());
    } else {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      if (googleAuth != null) {
        final credential = a.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(credential);
      }
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
  }

  Future<String?> createChat(String email) async {
    var user =
        await db.collection('users').where('email', isEqualTo: email).get();
    print('User: $user');
    if (user.docs.isNotEmpty) {
      // add to contacts
      await db
          .doc('users/${this.user.value!.id}')
          .collection('contacts')
          .doc(user.docs.first.id)
          .set({
        'email': user.docs.first['email'],
        'displayName': user.docs.first['displayName'],
        'photoURL': user.docs.first['photoURL'],
      });
      // create chat with target user.docs.first.id
      await db
          .doc('users/${this.user.value!.id}')
          .collection('chats')
          .doc(user.docs.first.id)
          .set({
        'target': {
          'id': user.docs.first.id,
          'displayName': user.docs.first['displayName'],
          'email': user.docs.first['email'],
          'photoURL': user.docs.first['photoURL'],
        },
        'title': user.docs.first['displayName'],
      });

      // add to chat
      // if (chats.value.any((element) => element.id == user.docs.first.id)) {
      //   final copy = [...chats.value];
      //   copy.add(
      //     Chat(
      //       id: user.docs.first.id,
      //       title: user.docs.first['displayName'],
      //       target: User(
      //         id: user.docs.first.id,
      //         displayName: user.docs.first['displayName'],
      //         email: user.docs.first['email'],
      //         photoURL: user.docs.first['photoURL'],
      //       ),
      //       chats: ChatStorage(
      //         collection: db
      //             .doc(
      //                 'users/${this.user.value!.id}/chats/${user.docs.first.id}')
      //             .collection('messages'),
      //       ),
      //     ),
      //   );
      //   chats.value = copy;
      //   print('Chat created with ${user.docs.first.id}');
      // }
      return user.docs.first.id;
    }
    return null;
  }

  Future<void> sendMessage(Chat chat, String text) async {
    await db
        .doc('users/${user.value!.id}/chats/${chat.id}')
        .collection('messages')
        .add({
      'sender': {
        'id': user.value!.id,
        'displayName': user.value!.displayName,
        'email': user.value!.email,
        'photoURL': user.value!.photoURL,
      },
      'text': text,
      'sentAt': DateTime.now().toIso8601String(),
      'edited': false,
    });

    // make sure the target has the chat
    await db.doc('users/${chat.target.id}/chats/${user.value!.id}').set({
      'target': {
        'id': user.value!.id,
        'displayName': user.value!.displayName,
        'email': user.value!.email,
        'photoURL': user.value!.photoURL,
      },
      'title': user.value!.displayName,
    }, SetOptions(merge: true));

    // send at the target
    await db
        .doc('users/${chat.target.id}/chats/${user.value!.id}')
        .collection('messages')
        .add({
      'sender': {
        'id': user.value!.id,
        'displayName': user.value!.displayName,
        'email': user.value!.email,
        'photoURL': user.value!.photoURL,
      },
      'text': text,
      'sentAt': DateTime.now().toIso8601String(),
      'edited': false,
    });
  }

  void deleteChat(Chat chat) {
    // delete the messages
    db
        .doc('users/${user.value!.id}/chats/${chat.id}')
        .collection('messages')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
    db
        .doc('users/${chat.target.id}/chats/${user.value!.id}')
        .collection('messages')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
    db.doc('users/${user.value!.id}/chats/${chat.id}').delete();
    db.doc('users/${chat.target.id}/chats/${user.value!.id}').delete();
  }

  void editChatTitle(Chat chat, String? text) {
    db.doc('users/${user.value!.id}/chats/${chat.id}').set({
      'title': text,
    }, SetOptions(merge: true));
    db.doc('users/${chat.target.id}/chats/${user.value!.id}').set({
      'title': text,
    }, SetOptions(merge: true));
  }
}

extension ModelRegistryExtension on BuildContext {
  ModelRegistry get model => of<ModelRegistry>();
  SelfUser get self => model.user.value
      as SelfUser; // never null (because its wrapped with StandardPage)
}
