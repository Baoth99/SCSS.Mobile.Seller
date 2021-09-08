import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
  }) : super(key: key);

  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Text(
        text,
        style: TextStyle(
          color: this.color,
          fontSize: this.fontSize,
          fontWeight: this.fontWeight,
        ),
        textAlign: this.textAlign,
      ),
    );
  }
}
