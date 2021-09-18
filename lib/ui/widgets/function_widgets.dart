import 'package:flutter/material.dart';
import 'package:seller_app/ui/widgets/arrow_back_button.dart';
import 'package:seller_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';

class FunctionalWidgets {
  static AppBar buildAppBar({
    required BuildContext context,
    Color? color,
    Color? backgroundColor,
    double? elevation,
    List<Widget>? action,
    Widget? title,
  }) {
    return AppBar(
      leading: ArrowBackIconButton(
        color: color,
      ),
      elevation: elevation,
      backgroundColor: backgroundColor,
      actions: action,
      title: title,
    );
  }

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
