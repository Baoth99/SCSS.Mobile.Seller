import 'package:seller_app/constants/constants.dart';

class UnauthorizedException implements Exception {
  final String cause;
  UnauthorizedException([this.cause = Symbols.empty]);
}
