part of 'constants.dart';

class Routes {
  static const initial = login;
  static const login = Symbols.forwardSlash + 'loginRoute';
  static const signupAddingPhoneNumber =
      Symbols.forwardSlash + 'signupAddingPhoneNumber';
  static const otpFillSignup = 'otpFillSignup';
}
