import 'package:formz/formz.dart';
import 'package:seller_app/constants/constants.dart';

enum BirthdateError { invalid }

class Birthdate extends FormzInput<DateTime?, BirthdateError> {
  const Birthdate.pure([DateTime? value]) : super.pure(value);
  const Birthdate.dirty([DateTime? value]) : super.dirty(value);

  bool _validate(DateTime? value) {
    return value != null && value.isBefore(DateTime.now());
  }

  @override
  BirthdateError? validator(DateTime? value) {
    return _validate(value) ? null : BirthdateError.invalid;
  }
}
