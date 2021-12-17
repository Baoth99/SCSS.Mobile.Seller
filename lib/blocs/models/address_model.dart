import 'package:formz/formz.dart';
import 'package:seller_app/constants/constants.dart';

enum AddressError { invalid }

class Address extends FormzInput<String, AddressError> {
  const Address.pure([String value = Symbols.empty]) : super.pure(value);
  const Address.dirty([String value = Symbols.empty]) : super.dirty(value);

  bool _validate(String value) {
    return value.isNotEmpty;
  }

  @override
  AddressError? validator(String value) {
    return _validate(value) ? null : AddressError.invalid;
  }
}
