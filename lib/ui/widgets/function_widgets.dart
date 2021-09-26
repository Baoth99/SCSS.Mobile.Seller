import 'package:flutter/material.dart';
import 'package:seller_app/ui/widgets/arrow_back_button.dart';
import 'package:seller_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FunctionalWidgets {
  static AppBar buildAppBar({
    required BuildContext context,
    Color? color,
    Color? backgroundColor,
    double? elevation,
    List<Widget>? action,
    Widget? title,
    bool? centerTitle,
  }) {
    return AppBar(
      leading: ArrowBackIconButton(
        color: color,
      ),
      elevation: elevation,
      backgroundColor: backgroundColor,
      actions: action,
      title: title,
      centerTitle: centerTitle,
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

  static Future<T?> showCustomModalBottomSheet<T>({
    required BuildContext context,
    String? title,
    required Widget child,
    required String routeClosed,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.0.r),
              topRight: Radius.circular(50.0.r),
            ),
          ),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          constraints: BoxConstraints(
            minHeight: 600.h,
          ),
          child: Container(
            margin: EdgeInsets.only(
              top: 100.h,
            ),
            height: 1700.h,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        title != null
                            ? Container(
                                padding: EdgeInsets.only(
                                  top: 20.h,
                                ),
                                child: CustomText(
                                  text: title,
                                  fontSize: 58.sp,
                                  color: Colors.grey[700],
                                ),
                              )
                            : const SizedBox.shrink(),
                        child,
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName(routeClosed),
                    );
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }
}
