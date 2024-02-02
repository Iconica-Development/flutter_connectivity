import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_connectivity/src/enums/connectivity_display_type_enum.dart';

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
  late ConnectivityDisplayType connectivityDisplayType;

  void init(
    BuildContext context,
    Widget screen,
    ConnectivityDisplayType connectivityDisplayType,
  ) {
    this.connectivityDisplayType = connectivityDisplayType;
    this.context = context;
    this.screen = screen;
  }

  @override
  void onConnectionLost() {
    var theme = Theme.of(context);
    if (!hasPushed) {
      if (connectivityDisplayType == ConnectivityDisplayType.screen) {
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
        return;
      }

      if (connectivityDisplayType == ConnectivityDisplayType.snackBar) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: theme.snackBarTheme.backgroundColor,
            content: screen,
            duration: const Duration(
              days: 1,
            ),
          ),
        );
        hasPushed = true;
        return;
      }

      if (connectivityDisplayType == ConnectivityDisplayType.popUp ||
          connectivityDisplayType == ConnectivityDisplayType.popUpDismissible) {
        var isDismissible =
            connectivityDisplayType != ConnectivityDisplayType.popUp;
        unawaited(
          showDialog(
            barrierDismissible: isDismissible,
            context: context,
            builder: (context) => PopScope(
              canPop: isDismissible,
              child: screen,
            ),
          ),
        );

        hasPushed = true;
        return;
      }
    }
  }

  @override
  void onConnectionRestored() {
    if (connectivityDisplayType == ConnectivityDisplayType.snackBar) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      hasPushed = false;
      return;
    }

    if (hasPushed && Navigator.canPop(context)) {
      Navigator.pop(context);
      hasPushed = false;
      return;
    }
  }
}
