import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neumo_caclulator/CalculatorView.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
  .then((_) {
    runApp(Calculator());
  });
}

class Calculator extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'DMSans'
      ),
      home: CalculatorView(),
    );
  }
}
