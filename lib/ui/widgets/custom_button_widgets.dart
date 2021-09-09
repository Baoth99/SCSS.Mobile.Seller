import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.fontSize,
    this.color,
    this.padding,
    this.margin,
    this.circularBorderRadius,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? fontSize;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? circularBorderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding,
      margin: this.margin,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          this.text,
          style: TextStyle(
            fontSize: this.fontSize,
          ),
        ),
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius:
                new BorderRadius.circular(this.circularBorderRadius ?? 0.r),
          ),
          primary: this.color,
          minimumSize: Size(
            this.width ?? double.minPositive,
            this.height ?? double.minPositive,
          ),
        ),
      ),
    );
  }
}
