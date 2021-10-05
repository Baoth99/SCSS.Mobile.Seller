import 'package:formz/formz.dart';
import 'package:seller_app/constants/constants.dart';

enum EmailError { invalid }

class Email extends FormzInput<String, EmailError> {
  const Email.dirty([String value = Symbols.empty]) : super.dirty(value);
  const Email.pure([String value = Symbols.empty]) : super.pure(value);

  bool _validate(String value) {
    return RegExp(RegexConstants.email).hasMatch(value);
  }

  @override
  EmailError? validator(String value) {
    return _validate(value) ? null : EmailError.invalid;
  }
}
