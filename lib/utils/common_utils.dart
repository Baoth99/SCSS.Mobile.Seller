import 'package:seller_app/constants/constants.dart';

class CommonUtils {
  static String toStringPadleft(int number, int width) {
    return number.toString().padLeft(width, '0');
  }

  static String concatString(List<String> strs,
      [String seperator = Symbols.space]) {
    return strs.join(seperator);
  }
}

class CommonTest {
  static Future<void> delay() async {
    return await Future<void>.delayed(
      const Duration(
        seconds: 2,
      ),
    );
  }
}
