import 'package:formz/formz.dart';

enum PhoneNumberError { invalid }

class PhoneNumber extends FormzInput<String, PhoneNumberError> {
  const PhoneNumber.dirty([String value = '']) : super.dirty(value);
  const PhoneNumber.pure([String value = '']) : super.pure(value);

  static bool _validate(String value) {
    return (value.length >= 9 && value.length <= 11);
  }

  @override
  PhoneNumberError? validator(String? value) {
    return _validate(value ?? '') ? null : PhoneNumberError.invalid;
  }
}
