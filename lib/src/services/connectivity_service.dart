// ignore_for_file: prefer_constructors_over_static_methods
// ignore_for_file: use_build_context_synchronously

import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_connectivity/flutter_connectivity.dart";
import "package:flutter_connectivity/src/services/pauseable_timer.dart";

/// Service that can be used to check for internet connection.
class Connectivity with WidgetsBindingObserver {
  Connectivity._() {
    WidgetsBinding.instance.addObserver(this);
  }

  static Connectivity? _instance;

  /// The instance of [Connectivity].
  static Connectivity get instance => _instance ??= Connectivity._();

  ConnectivityConfig? __config;
  ConnectivityConfig get _config =>
      __config ??= ConnectivityConfig.defaultConfig();
  // ignore: use_setters_to_change_properties
  void setCustomConfig(ConnectivityConfig config) => __config = config;

  bool _connection = true;
  bool _previousConnection = true;
  PausableTimer? _timer;

  /// Returns true if there is an internet connection.
  /// Returns false if there is no internet connection.
  bool get hasConnection => _connection;

  /// Starts the service.
  /// [context] is required when using the default handler.
  /// [fallBackScreen] is required when using the default handler.
  /// [fallBackScreen] is the screen that will be pushed when there is no
  /// internet connection.
  /// [fallBackScreen] is the screen that will be popped when there is an
  /// internet connection.
  /// [fallBackScreen] is only used when using the default handler.
  /// [noInternetEnum] is only used when using the default handler.
  void start({
    BuildContext? context,
    Widget? fallBackScreen,
    ConnectivityDisplayType? connectivityDisplayType,
  }) {
    _timer ??= PausableTimer.periodic(_config.duration, () async {
      _previousConnection = _connection;

      if (kIsWeb && _config.webUrl == null) {
        throw Exception(
          "To make flutter_connectivity work for web please specify a webUrl"
          " in the config. Make sure, CORS is not an issue",
        );
      }

      _connection = await _config.checker.checkConnection(_config);

      if (_config.handler is DefaultFlutterHandler) {
        if (context == null) {
          throw Exception("Context is required when using the default handler");
        }

        (_config.handler as DefaultFlutterHandler).init(
          context,
          fallBackScreen ??
              NoInternetScreen(
                connectivityDisplayType:
                    connectivityDisplayType ?? ConnectivityDisplayType.screen,
              ),
          connectivityDisplayType ?? ConnectivityDisplayType.screen,
        );
      }

      if (_previousConnection && !_connection) {
        _config.handler.onConnectionLost();
      } else if (!_previousConnection && _connection) {
        _config.handler.onConnectionRestored();
      }
    })
      ..start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_timer != null) {
        _timer!.start();
      }
    } else {
      _timer?.pause();
    }
  }
}
