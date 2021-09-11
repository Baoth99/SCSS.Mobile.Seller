import 'package:formz/formz.dart';
import 'package:seller_app/constants/constants.dart';

enum OTPCodeError { invalid }

class OTPCode extends FormzInput<String, OTPCodeError> {
  const OTPCode.pure([String value = '']) : super.pure(value);
  const OTPCode.dirty([String value = '']) : super.dirty(value);

  static bool _validate(String value) {
    return RegExp(RegexConstants.otpCode).hasMatch(value);
  }

  @override
  OTPCodeError? validator(String value) {
    return _validate(value) ? null : OTPCodeError.invalid;
  }
}
