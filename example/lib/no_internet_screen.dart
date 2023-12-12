import 'package:flutter/material.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: const Scaffold(
          body: Center(
            child: Text(
              'No internet :(',
            ),
          ),
        ),
      );
}
