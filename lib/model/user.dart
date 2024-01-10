import 'package:firebase_auth/firebase_auth.dart' as auth;

class User {
  final String id;
  String displayName;
  String email;
  String? photoURL;
  User({
    required this.id,
    required this.displayName,
    required this.email,
    required this.photoURL,
  });
}

class SelfUser extends User {
  final auth.User firebaseUser;
  SelfUser({
    required super.id,
    required super.displayName,
    required super.email,
    required super.photoURL,
    required this.firebaseUser,
  });
}
