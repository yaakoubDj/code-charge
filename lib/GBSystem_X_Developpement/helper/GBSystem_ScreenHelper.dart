import 'package:flutter/widgets.dart';

class GBSystem_ScreenHelper {
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
    // return 200;
  }

  static double screenHeight(BuildContext context) {
    // return 300;
    return MediaQuery.of(context).size.height;
  }

  static double screenWidthPercentage(BuildContext context, double percentage) {
    return screenWidth(context) * percentage;
    // return 200 * percentage;
  }

  static double screenHeightPercentage(
      BuildContext context, double percentage) {
    return screenHeight(context) * percentage;
    // return 300 * percentage;
  }
}
