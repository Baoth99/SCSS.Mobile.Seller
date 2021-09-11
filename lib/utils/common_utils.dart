import 'package:flutter/material.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';

class CommonUtils {
  static String toStringPadleft(int number, int width) {
    return number.toString().padLeft(width, '0');
  }

  static String concatString(List<String> strs) {
    return strs.join(Symbols.space);
  }
}

class WidgetUtils {
  static Future<T?> showCustomDialog<T>(BuildContext context, String text,
      [String? label]) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomProgressIndicatorDialog(
        text: text,
        semanticLabel: label,
      ),
    );
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
