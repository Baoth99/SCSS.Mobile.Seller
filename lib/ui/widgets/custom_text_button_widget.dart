import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize,
  }) : super(key: key);
  final String text;
  final Color? color;
  final VoidCallback onPressed;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: this.onPressed,
      child: Text(
        this.text,
        style: TextStyle(
          color: this.color,
          fontSize: this.fontSize,
        ),
      ),
    );
  }
}
