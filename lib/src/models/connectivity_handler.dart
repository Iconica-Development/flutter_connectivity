import 'dart:async';

import 'package:flutter/material.dart';

/// Implement this class to create a custom handler for internet connection.
abstract class ConnectivityHandler {
  void onConnectionLost();
  void onConnectionRestored();
}

/// Default implementation of [ConnectivityHandler].
class DefaultFlutterHandler implements ConnectivityHandler {
  bool hasPushed = false;

  late BuildContext context;
  late Widget screen;

  void init(BuildContext context, Widget screen) {
    this.context = context;
    this.screen = screen;
  }

  @override
  void onConnectionLost() {
    if (!hasPushed) {
      unawaited(
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PopScope(
              canPop: false,
              child: screen,
            ),
          ),
        ),
      );
      hasPushed = true;
    }
  }

  @override
  void onConnectionRestored() {
    if (hasPushed && Navigator.canPop(context)) {
      Navigator.pop(context);
      hasPushed = false;
    }
  }
}
