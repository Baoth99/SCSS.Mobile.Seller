import 'package:flutter/material.dart';

class DeviceConstant {
  static const double logicalWidth = 1080;
  static const double logicalHeight = 2220;
}

class AppConstant {
  static const String appTitle = "Seller";
  static const Color primaryColor = AppColor.orangeFFF5670A;
  static const Color accentColor = AppColor.greenFF61C53D;
}

class AppColor {
  static const Color greenFF61C53D = const Color(0xFF61C53D);
  static const Color orangeFFF5670A = const Color(0xFFF5670A);
  static const Color greyFF9098B1 = const Color(0xFF9098B1);
}

class ImagesPath {
  static const String loginLogo = 'assets/images/seller_login_logo.png';
}

class LoginWidgetConstant {
  static const String loginLogoImagePath = ImagesPath.loginLogo;
  static const String loginToContinue = 'Đăng nhập để tiếp tục';
  static const String phoneNumber = 'Số điện thoại';
  static const String password = 'Mật khẩu';
  static const String login = 'Đăng nhập';
  static const String forgetPassword = 'Quên mật khẩu?';
  static const String or = 'HOẶC';
  static const String createNewAccount = 'Tạo tài khoản mới';
}
