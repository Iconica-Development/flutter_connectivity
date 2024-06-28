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
    this.alignment,
    this.shape,
    this.contentPadding,
    this.insetPadding,
    this.closeButtonBuilder,
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

  /// Alignment for alert dialog.
  final AlignmentGeometry? alignment;

  /// Shape for alert dialog.
  final ShapeBorder? shape;

  /// Content padding for alert dialog.
  final EdgeInsetsGeometry? contentPadding;

  /// Inset padding for alert dialog.
  final EdgeInsets? insetPadding;

  /// Builder for close button. Can be used in case of dismissible pop up.
  final Widget? closeButtonBuilder;

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
        contentPadding: widget.contentPadding,
        insetPadding: widget.insetPadding ??
            const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
        alignment: widget.alignment,
        shape: widget.shape,
        backgroundColor: widget.backgroundColor ?? theme.colorScheme.surface,
        content: _ConnectivityWidget(
          widget: widget,
          theme: theme,
          closeButtonBuilder: widget.closeButtonBuilder,
        ),
      );
    }

    if (widget.connectivityDisplayType == ConnectivityDisplayType.snackBar) {
      return _ConnectivityWidget(widget: widget, theme: theme);
    }

    return Scaffold(
      backgroundColor: widget.backgroundColor ?? theme.colorScheme.surface,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: widget.horinzontalPadding),
          child: _ConnectivityWidget(
            widget: widget,
            theme: theme,
          ),
        ),
      ),
    );
  }
}

class _ConnectivityWidget extends StatelessWidget {
  const _ConnectivityWidget({
    required this.widget,
    required this.theme,
    this.closeButtonBuilder,
  });

  final NoInternetScreen widget;
  final ThemeData theme;
  final Widget? closeButtonBuilder;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (widget.connectivityDisplayType ==
              ConnectivityDisplayType.popUpDismissible)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                closeButtonBuilder ??
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
              ],
            )
          else
            const SizedBox(),
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
