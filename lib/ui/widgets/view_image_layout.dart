import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ViewImageLayout extends StatelessWidget {
  const ViewImageLayout({this.imageProvider, this.file, Key? key})
      : super(key: key);

  final File? file;
  final ImageProvider? imageProvider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: <Widget>[
          Center(
            child: file != null
                ? Image.file(
                    file!,
                  )
                : Image(image: imageProvider!),
          ),
          Positioned(
            top: 100.h,
            left: 50.w,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.close,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
