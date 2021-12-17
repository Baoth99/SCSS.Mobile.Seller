import 'package:flutter/material.dart';
import 'package:seller_app/constants/constants.dart';

class ArrowBackIconButton extends StatelessWidget {
  const ArrowBackIconButton({Key? key, this.color}) : super(key: key);

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        AppIcons.arrowBack,
        color: color,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
