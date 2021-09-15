import 'package:flutter/material.dart';

BoxDecoration bgDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [Colors.white, Colors.green[200]!],
    begin: const FractionalOffset(0.0, 1.0),
    end: const FractionalOffset(0.0, 1.0),
    stops: [0.0, 1.0],
    tileMode: TileMode.repeated,
  ),
);
