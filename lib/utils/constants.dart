import 'package:flutter/material.dart';

class DeviceConstants {
  static const double logicalWidth = 1080;
  static const double logicalHeight = 2220;
}

class AppConstants {
  static const String appTitle = "Seller";
  static const Color primaryColor = AppColors.orangeFFF5670A;
  static const Color accentColor = AppColors.greenFF61C53D;
}

class Routes {
  static const initial = login;
  static const login = 'loginRoute';
}

class AppColors {
  static const Color greenFF61C53D = const Color(0xFF61C53D);
  static const Color orangeFFF5670A = const Color(0xFFF5670A);
  static const Color greyFF9098B1 = const Color(0xFF9098B1);
}

class ImagesPaths {
  static const String loginLogo = 'assets/images/seller_login_logo.png';
}

class LoginWidgetConstants {
  static const String loginLogoImagePath = ImagesPaths.loginLogo;
  static const String loginToContinue = 'Đăng nhập để tiếp tục';
  static const String phoneNumber = 'Số điện thoại';
  static const String password = 'Mật khẩu';
  static const String login = 'Đăng nhập';
  static const String forgetPassword = 'Quên mật khẩu?';
  static const String or = 'HOẶC';
  static const String createNewAccount = 'Tạo tài khoản mới';
}
