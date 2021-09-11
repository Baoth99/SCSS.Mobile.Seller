part of 'constants.dart';

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
  static const String progressIndicatorLabel =
      'Progress Indicator for waiting to register Phone Nubmer.';
  static const String waiting = 'Vui lòng chờ...';
}

class OTPFillPhoneNumberLayoutConstants {
  static const String title = 'Nhập mã gồm 6 chữ số đã gửi tới';
  static const String notHaveCode = 'Chưa nhận được mã?';

  static const String hintText = '000000';
  static const int inputLength = Others.otpLength;
  static const int countdown = 30;

  static const String requetsNewCode =
      'Yêu cầu mã mới trong 00:$replacedSecondVar';
  static const String replacedSecondVar = '{second}';

  static const String checking = 'Đang kiểm tra.';
  static const String checkingProgressIndicator = 'Checking Progress Indicator';

  static const String resendOTP = 'Đang gửi lại mã OTP';
  static const String resendOTPProgressIndicator =
      'Resend OTP Progress Indicator';
}
