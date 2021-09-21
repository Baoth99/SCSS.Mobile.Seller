part of 'constants.dart';

class WidgetConstants {
  static const double buttonCommonFrontSize = 50;
  static const FontWeight buttonCommonFrontWeight = FontWeight.w500;
  static const double buttonCommonHeight = 120;
}

class LoginLayoutConstants {
  static const String loginLogoImagePath = ImagesPaths.loginLogo;
  static const String loginToContinue = 'Đăng nhập để tiếp tục';

  //Phone number
  static const String phoneNumber = 'Số điện thoại';
  static const String errorPhoneNumber = 'Hãy nhập số điện thoại';

  //Password
  static const String password = 'Mật khẩu';
  static const String errorPassword = 'Hãy nhập mật khẩu';

  static const String login = 'Đăng nhập';
  static const String forgetPassword = 'Quên mật khẩu?';
  static const String or = 'HOẶC';
  static const String signup = 'Tạo tài khoản mới';

  static const String waiting = 'Vui lòng đợi...';
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

class SignupInformationLayoutConstants {
  static const String title = 'Hoàn tất đăng ký';

  static const String labelName = 'Họ Tên';
  static const String hintName = 'Nhập tối thiểu 1 ký tự';
  static const String errorName = 'Xin hãy nhập tối thiểu 1 ký tự!';

  static const String labelGender = 'Giới tính';
  static const String male = 'Nam';
  static const String female = 'Nữ';

  static const String labelPassword = 'Mật khẩu';
  static const String hintPassword = 'Nhập tối thiểu 1 ký tự';
  static const String errorPassword = 'Xin hãy nhập tối thiểu 1 ký tự!';

  static const String labelRepeatPassword = 'Nhập lại mật khẩu';
  static const String hintRepeatPassword = 'Nhập giống với mật khẩu';
  static const String errorRepeatPassword = 'Xác nhận mật khẩu không khớp!';

  static const String labelSubmmitedButton = 'Xong';

  //input constants
  static const double circularBorderRadius = 15.0;

  //show dialog
  static const String waiting = 'Vui lòng đợi...';
  static const String titleDialog = 'Thông báo';
  static const String success = 'Bạn đã đăng ký thành công';
  static const String btnDialogName = 'Xác nhận';
}

class BookingStartLayoutConstants {
  //common
  static const double inputFontSize = 45;

  //first page
  static const String title = 'Đặt hẹn thu gom';
  static const String subTitle = 'Chọn địa chỉ và thời gian thu gom mong muốn';

  static const String placeHintText = 'Thu gom ở ...';

  static const String timeHintText = 'Thời gian thu gom';

  static const String noteHintText = 'Ghi chú cho người thu gom';
  static const String firstButtonTitle = 'Tiếp';
}

class BookingMapPickerLayoutConstants {
  static const String markerPath = ImagesPaths.markerPoint;
  static const String submittedButton = 'Xác nhận';

  static const int minuteInterval = 15;
}
