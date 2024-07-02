// ignore_for_file: one_member_abstracts

import "dart:io";

import "package:flutter/foundation.dart";
import "package:flutter_connectivity/flutter_connectivity.dart";
import "package:http/http.dart";

/// Implement this class to create a custom check for internet connection.
/// Default implementation is [InternetChecker].
abstract class ConnectivityChecker {
  Future<bool> checkConnection(ConnectivityConfig config);
}

/// Default implementation of [ConnectivityChecker].
class InternetChecker implements ConnectivityChecker {
  Future<bool> checkConnectionWeb(ConnectivityConfig config) async {
    try {
      await get(
        Uri.parse(config.webUrl!),
      );

      return true;
    } on Exception catch (_) {
      return false;
    }
  }

  Future<bool> checkConnectionIO(ConnectivityConfig config) async {
    try {
      var result = await InternetAddress.lookup(config.url);
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    } on Exception catch (_) {
      return false;
    }

    return false;
  }

  @override
  Future<bool> checkConnection(ConnectivityConfig config) async {
    if (kIsWeb) {
      return checkConnectionWeb(config);
    } else {
      return checkConnectionIO(config);
    }
  }
}
