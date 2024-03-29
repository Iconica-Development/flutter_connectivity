[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart)

Package that can be used to check for an internet connection in your application

Figma Design that defines this component (only accessible for Iconica developers): https://www.figma.com/file/4WkjwynOz5wFeFBRqTHPeP/Iconica-Design-System?type=design&node-id=516%3A1847&mode=design&t=XulkAJNPQ32ARxWh-1
Figma clickable prototype that demonstrates this component (only accessible for Iconica developers): https://www.figma.com/proto/4WkjwynOz5wFeFBRqTHPeP/Iconica-Design-System?type=design&node-id=340-611&viewport=-4958%2C-31%2C0.33&t=XulkAJNPQ32ARxWh-0&scaling=min-zoom&starting-point-node-id=516%3A3402&show-proto-sidebar=1

## Setup

See [example](./example/lib/main.dart) app for a guide

## How to use

Using the default handler for Flutter

```dart
Connectivity.instance.start(
    context: context,
    connectivityDisplayType: ConnectivityDisplayType.screen, // enum to set how the connectivity widget will display, Default ConnectivityDisplayType.screen.
    fallBackScreen: const NoInternetScreen(
      connectivityDisplayType: ConnectivityDisplayType.screen,
    ), // Screen to show when no internet has been detected. NoInternetScreen is a screen provided by this package but any can be used. When you override the default implementation of the fallBackScreen make sure you also give the same connectivityDisplayType to the fallBackScreen.
);
```

If you are going to use the SnackBar option and you want to change the backgroundColor set a backgroundColor for the SnackBar in your theme like so:

```
snackBarTheme: const SnackBarThemeData(
  backgroundColor: Colors.red,
)
```

Make sure to call the `.start()` and other methods somewhere in the app where there is a navigator in your context when using the default handler.

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
