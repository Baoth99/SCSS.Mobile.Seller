import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBorderTextFormField extends StatefulWidget {
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
    this.empty = false,
    this.autofocus = false,
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
  final bool empty;
  final bool autofocus;

  @override
  _CustomBorderTextFormFieldState createState() =>
      _CustomBorderTextFormFieldState();
}

class _CustomBorderTextFormFieldState extends State<CustomBorderTextFormField> {
  final fieldText = TextEditingController();
  final focusNode = FocusNode();

  @override
  void didUpdateWidget(covariant CustomBorderTextFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.empty) {
      fieldText.clear();
      if (widget.autofocus) {
        focusNode.requestFocus();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    fieldText.dispose();
    focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(0),
      child: TextFormField(
        focusNode: focusNode,
        controller: fieldText,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        inputFormatters: widget.inputFormatters,
        enableSuggestions: false,
        autocorrect: false,
        style: widget.style,
        decoration: InputDecoration(
          errorText: widget.errorText,
          labelText: widget.labelText,
          labelStyle: widget.labelStyle,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              widget.cirularBorderRadius ?? 0.r,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: widget.commonColor,
            ),
            borderRadius: BorderRadius.circular(
              widget.cirularBorderRadius ?? 0.r,
            ),
          ),
          contentPadding: widget.contentPadding,
        ),
      ),
    );
  }
}
