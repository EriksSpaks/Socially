import 'package:flutter/cupertino.dart';

class RelativeSize {
  RelativeSize({required this.context});
  final BuildContext context;

  double getScreenHeightPercentage(double percentage) {
    return MediaQuery.of(context).size.height * percentage;
  }

  double getScreenWidthPercentage(double percentage) {
    return MediaQuery.of(context).size.width * percentage;
  }
}
