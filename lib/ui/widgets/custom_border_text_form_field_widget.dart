import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBorderTextFormField extends StatelessWidget {
  const CustomBorderTextFormField({
    Key? key,
    this.labelText,
    this.commonColor = AppColors.greenFF61C53D,
    this.keyboardType = TextInputType.multiline,
    this.obscureText = false,
    this.inputFormatters = const [],
    this.labelStyle,
    this.hintText,
    this.hintStyle,
    this.padding,
    this.contentPadding,
    this.cirularBorderRadius,
    this.style,
    this.onChanged,
    this.errorText,
  }) : super(key: key);
  final String? labelText;
  final Color commonColor;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter> inputFormatters;
  final TextStyle? labelStyle;
  final String? hintText;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? contentPadding;
  final double? cirularBorderRadius;
  final TextStyle? style;
  final void Function(String)? onChanged;
  final String? errorText;

  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(0),
      child: TextFormField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
        enableSuggestions: false,
        autocorrect: false,
        style: style,
        decoration: InputDecoration(
          errorText: errorText,
          labelText: labelText,
          labelStyle: labelStyle,
          hintText: hintText,
          hintStyle: hintStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              cirularBorderRadius ?? 0.r,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: commonColor,
            ),
            borderRadius: BorderRadius.circular(
              cirularBorderRadius ?? 0.r,
            ),
          ),
          contentPadding: contentPadding,
        ),
      ),
    );
  }
}
