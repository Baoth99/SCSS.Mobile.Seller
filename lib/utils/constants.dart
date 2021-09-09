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
  static const login = Symbols.forwardSlash + 'loginRoute';
  static const signupAddingPhoneNumber =
      Symbols.forwardSlash + 'signupAddingPhoneNumber';
}

class AppIcons {
  static const IconData arrowBack = Icons.arrow_back_ios_new_outlined;
}

class AppColors {
  static const Color greenFF61C53D = const Color(0xFF61C53D);
  static const Color orangeFFF5670A = const Color(0xFFF5670A);
  static const Color greyFF9098B1 = const Color(0xFF9098B1);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Colors.red;
  static const Color greyFFDADADA = const Color(0xFFDADADA);
}

class ImagesPaths {
  static const String loginLogo = 'assets/images/seller_login_logo.png';
}

class Symbols {
  static const String forwardSlash = '/';
  static const String vietnamISOCode = 'VN';
  static const String vietnamCallingCode = '+84';
}

class LoginLayoutConstants {
  static const String loginLogoImagePath = ImagesPaths.loginLogo;
  static const String loginToContinue = 'Đăng nhập để tiếp tục';
  static const String phoneNumber = 'Số điện thoại';
  static const String password = 'Mật khẩu';
  static const String login = 'Đăng nhập';
  static const String forgetPassword = 'Quên mật khẩu?';
  static const String or = 'HOẶC';
  static const String signup = 'Tạo tài khoản mới';
}

class PhoneNumberSignupLayoutConstants {
  static const String welcomeTitle =
      'Chào mừng bạn! Số điện thoại của bạn là gì?';
  static const String phoneNumberHint = '87654321';
  static const String next = 'Tiếp';
  static const String errorText = 'Số di động có vẻ không chính xác.';
}
