[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart) 

Package that can be used to check for an internet connection in your application

## Setup

See [example](./example/lib/main.dart) app for a guide

## How to use

Using the default handler for Flutter
```dart
Connectivity.instance.start(
    context: context,
    fallBackScreen: const NoInternet(), // Screen to show when no internet has been detected
);
``` 
Make sure to call the ```.start()``` and other methods somewhere in the app where there is a navigator in your context when using the default handler.

Configuration can be customzied using the following method:
```dart
Connectivity.instance.setCustomConfig(
    ConnectivityConfig(
        url: 'www.iconica.nl',
        handler: CustomHandler(),
        checker: CustomInternetChecker(),
    ),
);
```

CustomHandler and CustomInterChecker are implementations of an abstract class, which look something like:

```dart
class CustomHandler implements ConnectivityHandler {
  @override
  void onConnectionLost() {
    debugPrint('Connection lost');
  }

  @override
  void onConnectionRestored() {
    debugPrint('Connection restored');
  }
}
```

```dart
class CustomInternetChecker implements ConnectivityChecker {
  @override
  Future<bool> checkConnection() async {
    try {
      var result = await InternetAddress.lookup('google.nl');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
```

When using a custom handler, the instance can be started without the context and fallBackScreen parameters
```dart
Connectivity.instance.start();
```

For a complete overview of how to use it look at the [example](./example/lib/main.dart) app


## Issues

Please file any issues, bugs or feature request as an issue on our [GitHub](https://github.com/Iconica-Development/flutter_connectivity) page. Commercial support is available if you need help with integration with your app or services. You can contact us at [support@iconica.nl](mailto:support@iconica.nl).

## Want to contribute

If you would like to contribute to the plugin (e.g. by improving the documentation, solving a bug or adding a cool new feature), please carefully review our [contribution guide](../CONTRIBUTING.md) and send us your [pull request](https://github.com/Iconica-Development/flutter_connectivity/pulls).

## Author

This flutter_connectivity package for Flutter is developed by [Iconica](https://iconica.nl). You can contact us at <support@iconica.nl>