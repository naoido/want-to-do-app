import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

const _defaultPageTransition = SharedAxisPageTransitionsBuilder(
  transitionType: SharedAxisTransitionType.horizontal,
);

final appTheme = ThemeData(
  primarySwatch: Colors.blue,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: _defaultPageTransition,
    TargetPlatform.iOS: _defaultPageTransition,
  }),
);