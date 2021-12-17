import 'package:formz/formz.dart';
import 'package:seller_app/constants/constants.dart';

enum LoginPhoneNumberError { empty }

class LoginPhoneNumber extends FormzInput<String, LoginPhoneNumberError> {
  const LoginPhoneNumber.pure([String value = Symbols.empty])
      : super.pure(value);
  const LoginPhoneNumber.dirty([String value = Symbols.empty])
      : super.dirty(value);

  bool _validate(String value) {
    return value.isNotEmpty;
  }

  @override
  LoginPhoneNumberError? validator(String value) {
    return _validate(value) ? null : LoginPhoneNumberError.empty;
  }
}

// enum LoginPasswordError { empty }

// class LoginPassword extends FormzInput<String, LoginPasswordError> {
//   const LoginPassword.pure([String value = Symbols.empty]) : super.pure(value);
//   const LoginPassword.dirty([String value = Symbols.empty])
//       : super.dirty(value);

//   bool _validate(String value) {
//     return value.isNotEmpty;
//   }

//   @override
//   LoginPasswordError? validator(String value) {
//     return _validate(value) ? null : LoginPasswordError.empty;
//   }
// }
