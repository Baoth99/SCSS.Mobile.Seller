part of 'constants.dart';

class Routes {
  //initial
  static const initial = login;

  //login
  static const login = Symbols.forwardSlash + 'loginRoute';

  //main
  static const main = 'main';

  //signup
  static const signupPhoneNumber = Symbols.forwardSlash + 'signupPhoneNumber';
  static const signupOTP = 'signupOTP';
  static const signupInformation = 'signupInformation';

  //Booking
  static const String bookingStart = 'bookingStart';
  static const String bookingLocationPicker = 'bookingLocationPicker';
  static const bookingMapPicker = 'bookingMapPicker';
  static const bookingBulky = 'bookingBulky';

  //Booking Detail
  static const bookingDetail = 'bookingDetail';

  //activity
  static const profileEdit = 'profileEdit';
}
