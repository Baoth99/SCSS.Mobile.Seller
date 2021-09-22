import 'package:flutter/material.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';

class SubmittedButton extends StatelessWidget {
  const SubmittedButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final void Function() Function(BuildContext) onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed(context),
      style: ElevatedButton.styleFrom(
        textStyle: TextStyle(
          fontSize: WidgetConstants.buttonCommonFrontSize.sp,
          fontWeight: WidgetConstants.buttonCommonFrontWeight,
        ),
        primary: AppColors.greenFF61C53D,
        minimumSize: Size(
          double.infinity,
          WidgetConstants.buttonCommonHeight.h,
        ),
      ),
      child: CustomText(
        text: title,
      ),
    );
  }
}
