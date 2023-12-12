// ignore_for_file: prefer_initializing_formals

import 'package:flutter_connectivity/src/models/connectivity_checker.dart';
import 'package:flutter_connectivity/src/models/connectivity_handler.dart';

/// Configuration for [Connectivity].
class ConnectivityConfig {
  /// The url to check for internet connection. Default is 'google.nl'.
  /// Only used when [checker] is not set.
  final String url;

  /// Due to CORS, to make it work for a web a specific URL must be speciefied
  final String? webUrl;

  /// The handler for [Connectivity].
  /// Default is [DefaultFlutterHandler].
  late ConnectivityHandler handler;

  /// The duration for [Connectivity]. Determines how often the connection is checked.
  /// Default is 3 seconds.
  final Duration duration;

  /// The checker for [Connectivity].
  /// Default is [InternetChecker].
  late ConnectivityChecker checker;

  /// Default configuration for [Connectivity].
  factory ConnectivityConfig.defaultConfig() => ConnectivityConfig();

  /// Create a custom configuration for [Connectivity].
  ConnectivityConfig({
    this.url = 'google.nl',
    this.webUrl,
    this.duration = const Duration(seconds: 3),
    handler,
    checker,
  }) {
    checker ??= InternetChecker();
    handler ??= DefaultFlutterHandler();

    this.checker = checker;
    this.handler = handler;
  }
}
