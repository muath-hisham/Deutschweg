import 'package:get/get.dart';

class Dimensions {
  static final double _screenHeight = Get.context!.height;
  static final double _screenWidth = Get.context!.width;

  static double get getScreenHeight => _screenHeight;
  static double get getScreenWidth => _screenWidth;

  static const double _myScreenHeight = 780;
  static const double _myScreenWidth = 360;

  static const double horizontalSpace = 5;

  static double height(double x) {
    return _screenHeight / (_myScreenHeight / x);
  }

  static double width(double x) {
    return _screenWidth / (_myScreenWidth / x);
  }

  static double vertical(double x) {
    return _screenHeight / (_myScreenHeight / x);
  }

  static double horizontal(double x) {
    return _screenWidth / (_myScreenWidth / x);
  }

  static double fontSize(double x) {
    return _screenWidth / (_myScreenWidth / x);
  }
}
