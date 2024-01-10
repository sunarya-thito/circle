import 'package:circle/components/data_widget.dart';
import 'package:flutter/material.dart';

import 'model/user.dart';

class ClientApp {
  final ValueNotifier<User?> user = ValueNotifier(null);
}

extension ClientAppExtension on BuildContext {
  ClientApp get app => of<ClientApp>();
}
