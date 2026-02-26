import 'package:flutter/material.dart';

/// Design token: border radius values.
abstract class AppRadius {
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 24;
  static const double full = 999;

  static const sm_   = BorderRadius.all(Radius.circular(sm));
  static const md_   = BorderRadius.all(Radius.circular(md));
  static const lg_   = BorderRadius.all(Radius.circular(lg));
  static const xl_   = BorderRadius.all(Radius.circular(xl));
  static const full_ = BorderRadius.all(Radius.circular(full));
}
