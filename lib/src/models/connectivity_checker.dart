import 'dart:io';

import 'package:flutter_connectivity/flutter_connectivity.dart';

/// Implement this class to create a custom check for internet connection.
/// Default implementation is [InternetChecker].
abstract class ConnectivityChecker {
  Future<bool> checkConnection();
}

/// Default implementation of [ConnectivityChecker].
class InternetChecker implements ConnectivityChecker {
  InternetChecker(this.config);

  final ConnectivityConfig config;

  @override
  Future<bool> checkConnection() async {
    try {
      var result = await InternetAddress.lookup(config.url);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
