// ignore: import_of_legacy_library_into_null_safe
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
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
    Container? flexibleSpace,
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
      flexibleSpace: flexibleSpace,
    );
  }

  static Future<dynamic> showAwesomeDialog(
    BuildContext context, {
    String title = 'Thông báo',
    required String desc,
    String btnOkText = 'OK',
    void Function()? btnOkOnpress,
    Color btnOkColor = const Color(0xFF00CA71),
    Color textOkColor = AppColors.white,
    bool isOkBorder = false,
    String? btnCancelText,
    void Function()? btnCancelOnpress,
    Color btnCancelColor = Colors.transparent,
    Color textCancelColor = AppColors.red,
    bool isCancelBorder = true,
    DialogType? dialogType,
    bool dismissBack = true,
    String? okRoutePress,
  }) {
    if (okRoutePress != null && btnOkOnpress != null) {
      throw Exception('showAwesomeDialog: either okRoutePress or btnOkOnpress');
    } else if (okRoutePress != null && btnOkOnpress == null) {
      btnOkOnpress ??= () {
        Navigator.of(context).popUntil(ModalRoute.withName(okRoutePress));
      };
    } else {
      btnOkOnpress ??= () {
        Navigator.of(context).pop();
      };
    }

    btnCancelOnpress ??= () {
      Navigator.of(context).pop();
    };
    return AwesomeDialog(
      context: context,
      title: title,
      desc: desc,
      dialogType: dialogType,
      btnOk: getDialogButton(
        title: btnOkText,
        onPressed: btnOkOnpress,
        buttonColor: btnOkColor,
        textColor: textOkColor,
        isBorder: isOkBorder,
      ),
      btnCancel: btnCancelText != null && btnCancelText.isNotEmpty
          ? getDialogButton(
              title: btnCancelText,
              onPressed: btnCancelOnpress,
              buttonColor: btnCancelColor,
              textColor: textCancelColor,
              isBorder: isCancelBorder,
            )
          : null,
      dismissOnTouchOutside: !dismissBack,
      dismissOnBackKeyPress: !dismissBack,
    ).show();
  }

  static Future<T?> showCustomDialog<T>(BuildContext context,
      [String text = 'Vui lòng đợi...', String? label]) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        child: CustomProgressIndicatorDialog(
          text: text,
          semanticLabel: label,
        ),
        onWillPop: () async => false,
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

  static Widget getLoadingAnimation() {
    return const SpinKitRing(
      color: AppColors.greenFF61C53D,
    );
  }

  static Widget getErrorIcon() {
    return Icon(
      Icons.error,
      size: 180.sp,
      color: AppColors.red,
    );
  }

  static Future<dynamic> showErrorSystemRouteButton(
    BuildContext context, {
    String title = 'Thông báo',
    String? route,
  }) {
    return showAwesomeDialog(
      context,
      title: title,
      desc: InvalidRequestCode.errorSystem,
      dialogType: DialogType.ERROR,
      btnOkText: 'Đóng',
      isOkBorder: true,
      btnOkColor: AppColors.errorButtonBorder,
      textOkColor: AppColors.errorButtonText,
      okRoutePress: route,
    );
  }

  // static Future<bool?> showDialogCloseRouteButton(
  //   BuildContext context,
  //   String title, {
  //   String? desc,
  //   AlertType alertType = AlertType.error,
  //   String buttonTitle = 'Đóng',
  //   Color? colorButton,
  //   bool onWillPopActive = false,
  //   String? route,
  // }) {
  //   return showDialogCloseButton(
  //     context,
  //     title,
  //     desc: desc,
  //     alertType: alertType,
  //     buttonTitle: buttonTitle,
  //     colorButton: colorButton,
  //     onWillPopActive: onWillPopActive,
  //     onPressed: () {
  //       if (route == null) {
  //         Navigator.of(context).pop();
  //       } else {
  //         Navigator.of(context).popUntil(ModalRoute.withName(route));
  //       }
  //     },
  //   );
  // }

  // static Future<bool?> showDialogCloseButton(
  //   BuildContext context,
  //   String title, {
  //   String? desc,
  //   AlertType alertType = AlertType.none,
  //   String buttonTitle = 'Đóng',
  //   Color? colorButton,
  //   bool onWillPopActive = false,
  //   required void Function() onPressed,
  // }) {
  //   return Alert(
  //     closeIcon: Container(),
  //     context: context,
  //     type: alertType,
  //     title: title,
  //     onWillPopActive: onWillPopActive,
  //     desc: desc,
  //     buttons: [
  //       getDialogButton(
  //         title: buttonTitle,
  //         onPressed: onPressed,
  //         buttonColor: colorButton,
  //       )
  //     ],
  //   ).show();
  // }

  // static Future<bool?> showDialogTwoButton(
  //   BuildContext context,
  //   String desc,
  //   String yesTitle,
  //   String noTitle, {
  //   String title = Symbols.empty,
  //   AlertType alertType = AlertType.none,
  //   Color? yesButtonColor,
  //   Color noButtonColor = Colors.transparent,
  //   bool isNoButtonBorder = true,
  // }) {
  //   return Alert(
  //     context: context,
  //     type: alertType,
  //     title: title,
  //     desc: desc,
  //     buttons: [
  //       getDialogButton(
  //         title: noTitle,
  //         onPressed: () {
  //           Navigator.of(context).pop(false);
  //         },
  //         buttonColor: noButtonColor,
  //         textColor: Colors.grey[700]!,
  //         isBorder: isNoButtonBorder,
  //       ),
  //       getDialogButton(
  //         title: yesTitle,
  //         onPressed: () {
  //           Navigator.of(context).pop(true);
  //         },
  //         buttonColor: yesButtonColor,
  //       ),
  //     ],
  //   ).show();
  // }

  static getDialogButton({
    required String title,
    required void Function() onPressed,
    required Color buttonColor,
    Color textColor = Colors.white,
    double? width,
    bool isBorder = false,
  }) {
    return DialogButton(
      border: isBorder
          ? Border.all(
              color: buttonColor,
            )
          : Border.all(
              style: BorderStyle.none,
            ),
      child: CustomText(
        text: title,
        color: textColor,
        fontSize: 50.sp,
        fontWeight: FontWeight.w500,
      ),
      color: isBorder ? Colors.transparent : buttonColor,
      onPressed: onPressed,
      width: width,
    );
  }
}
