part of 'constants.dart';

class RegexConstants {
  static final String otpCode = r'^\d{' + Others.otpLength.toString() + r'}$';
}
