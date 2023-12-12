import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_connectivity/flutter_connectivity.dart';

/// Service that can be used to check for internet connection.
class Connectivity {
  Connectivity._();

  static Connectivity? _instance;

  /// The instance of [Connectivity].
  static Connectivity get instance => _instance ??= Connectivity._();

  ConnectivityConfig? __config;
  ConnectivityConfig get _config =>
      __config ?? ConnectivityConfig.defaultConfig();
  void setCustomConfig(ConnectivityConfig config) => __config = config;

  bool _connection = true;
  bool _previousConnection = true;
  Timer? _timer;

  /// Returns true if there is an internet connection.
  /// Returns false if there is no internet connection.
  bool get hasConnection => _connection;

  /// Starts the service.
  /// [context] is required when using the default handler.
  /// [fallBackScreen] is required when using the default handler.
  /// [fallBackScreen] is the screen that will be pushed when there is no internet connection.
  /// [fallBackScreen] is the screen that will be popped when there is an internet connection.
  /// [fallBackScreen] is only used when using the default handler.
  void start({BuildContext? context, Widget? fallBackScreen}) {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      throw Exception('This package only works on Android and iOS');
    }

    _timer ??= Timer.periodic(const Duration(seconds: 3), (t) async {
      _previousConnection = _connection;

      _connection = await _config.checker.checkConnection();

      if (_config.handler is DefaultFlutterHandler) {
        if (context == null || fallBackScreen == null) {
          throw Exception(
              'Context and screen are required when using the default handler');
        }

        // ignore: use_build_context_synchronously
        (_config.handler as DefaultFlutterHandler)
            .init(context, fallBackScreen);
      }

      if (_previousConnection && !_connection) {
        _config.handler.onConnectionLost();
      } else if (!_previousConnection && _connection) {
        _config.handler.onConnectionRestored();
      }
    });
  }
}
