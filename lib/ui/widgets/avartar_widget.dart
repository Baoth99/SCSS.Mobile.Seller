import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/constants/constants.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    required this.imagePath,
    required this.isMale,
    Key? key,
  }) : super(key: key);
  final String imagePath;
  final bool isMale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 450.w,
      child: CircleAvatar(
        onForegroundImageError: (exception, stackTrace) {},
        radius: 225.r,
        foregroundImage: imagePath.isNotEmpty
            ? NetworkImage(
                imagePath,
              )
            : getFalloutImage() as ImageProvider,
        backgroundImage: getFalloutImage(),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 6.0,
        ),
      ),
    );
  }

  AssetImage getFalloutImage() {
    return AssetImage(
      isMale ? ImagesPaths.maleProfile : ImagesPaths.femaleProfile,
    );
  }
}
