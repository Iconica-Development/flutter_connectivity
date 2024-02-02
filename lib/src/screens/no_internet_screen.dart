import 'package:flutter/material.dart';
import 'package:flutter_connectivity/src/enums/connectivity_display_type_enum.dart';

/// Standard screen to use as fallback.
class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({
    required this.connectivityDisplayType,
    this.titleText = 'No internet',
    this.underTitleText = 'It seems like you don\'t have an active internet '
        'connection. Please check your network and try again.',
    this.titleTextStyle,
    this.underTitleTextStyle,
    this.titleSpacer = 8,
    this.title,
    this.underTitle,
    this.backgroundColor,
    this.horinzontalPadding = 16,
    super.key,
  });

  /// Text of the title. Overridden if [title] is set.
  final String titleText;

  /// Text of the under title. Overridden if [underTitle] is set.
  final String underTitleText;

  /// Textstyle of the title. Overridden if [title] is set.
  final TextStyle? titleTextStyle;

  /// Textstyle of the under title. Overridden if [underTitle] is set.
  final TextStyle? underTitleTextStyle;

  /// Height between the title and under title.
  final double titleSpacer;

  /// Widget to override the standard title.
  final Widget? title;

  /// Widget to override the standard under title.
  final Widget? underTitle;

  /// Color of the background. If null the background of the colorScheme
  /// is used.
  final Color? backgroundColor;

  /// Padding for the text on the horinzontal sides.
  final double horinzontalPadding;

  /// Enum to determine which fallback widget to use.
  final ConnectivityDisplayType connectivityDisplayType;

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if (widget.connectivityDisplayType == ConnectivityDisplayType.popUp ||
        widget.connectivityDisplayType ==
            ConnectivityDisplayType.popUpDismissible) {
      return AlertDialog(
        backgroundColor: widget.backgroundColor ?? theme.colorScheme.background,
        content: _ConnectivityWidget(widget: widget, theme: theme),
      );
    }

    if (widget.connectivityDisplayType == ConnectivityDisplayType.snackBar) {
      return _ConnectivityWidget(widget: widget, theme: theme);
    }

    return Scaffold(
      backgroundColor: widget.backgroundColor ?? theme.colorScheme.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.horinzontalPadding),
          child: _ConnectivityWidget(widget: widget, theme: theme),
        ),
      ),
    );
  }
}

class _ConnectivityWidget extends StatelessWidget {
  const _ConnectivityWidget({
    required this.widget,
    required this.theme,
  });

  final NoInternetScreen widget;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.title ??
              Text(
                widget.titleText,
                style: widget.titleTextStyle ?? theme.textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
          SizedBox(
            height: widget.titleSpacer,
          ),
          widget.underTitle ??
              Text(
                widget.underTitleText,
                style: widget.underTitleTextStyle ?? theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
        ],
      );
}
