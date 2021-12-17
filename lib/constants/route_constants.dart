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

  //Request
  static const String requestStart = 'requestStart';
  static const String requestLocationPicker = 'requestLocationPicker';
  static const requestMapPicker = 'requestMapPicker';
  static const requestBulky = 'requestBulky';

  //Request Detail
  static const requestDetail = 'requestDetail';

  //activity
  static const profileEdit = 'profileEdit';
  static const profilePasswordEdit = 'profilePasswordEdit';

  //edit password
  static const forgetPasswordPhoneNumber = 'editPasswordPhoneNumber';
  static const forgetPasswordOTP = 'forgetPasswordOTP';
  static const forgetPasswordNewPassword = 'forgetPasswordNewPassword';

  //splash screen
  static const splashScreen = 'splashScreen';
}
