import 'package:flutter/material.dart';

class CustomFontSize {
  static double mediumFontSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.05;
  }

    static double BigFontSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.1;
  }

  static double smallFontSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.035;
  }
}


class IconSize {
  static double mediumIconSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.05;
  }

    static double BigIconSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.1;
  }

  static double smalIconSize(BuildContext context) {
    return MediaQuery.of(context).size.width * 0.035;
  }
}