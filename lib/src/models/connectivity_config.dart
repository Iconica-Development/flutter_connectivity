import 'package:flutter_connectivity/src/models/connectivity_checker.dart';
import 'package:flutter_connectivity/src/models/connectivity_handler.dart';

/// Configuration for [Connectivity].
class ConnectivityConfig {
  /// The url to check for internet connection. Default is 'google.nl'.
  /// Only used when [checker] is not set.
  final String url;

  /// The handler for [Connectivity].
  /// Default is [DefaultFlutterHandler].
  late ConnectivityHandler handler;

  /// The checker for [Connectivity].
  /// Default is [InternetChecker].
  late ConnectivityChecker checker;

  /// Default configuration for [Connectivity].
  factory ConnectivityConfig.defaultConfig() => ConnectivityConfig();

  /// Create a custom configuration for [Connectivity].
  ConnectivityConfig({
    this.url = 'google.nl',
    handler,
    checker,
  }) {
    checker ??= InternetChecker(this);
    handler ??= DefaultFlutterHandler();
  }
}
