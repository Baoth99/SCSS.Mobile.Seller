import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/utils/common_utils.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    required this.imagePath,
    required this.isMale,
    this.width = 450,
    Key? key,
  }) : super(key: key);
  final String imagePath;
  final bool isMale;
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      child: FutureBuilder<List>(
        future: getMetaDataImage(imagePath),
        builder: (c, snapshot) {
          return CircleAvatar(
            radius: (width / 2).r,
            onForegroundImageError: (exception, stackTrace) => print(exception),
            foregroundImage: imagePath.isNotEmpty && snapshot.hasData
                ? NetworkImage(snapshot.data![0], headers: {
                    HttpHeaders.authorizationHeader: snapshot.data![1],
                  })
                : getFalloutImage() as ImageProvider,
            backgroundImage: getFalloutImage(),
          );
        },
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

  Future<List> getMetaDataImage(String imagePath) async {
    var bearerToken = NetworkUtils.getBearerToken();
    var url = NetworkUtils.getUrlWithQueryString(
      APIServiceURI.imageGet,
      {'imageUrl': imagePath},
    );
    return [
      url,
      await bearerToken,
    ];
  }

  AssetImage getFalloutImage() {
    return AssetImage(
      isMale ? ImagesPaths.maleProfile : ImagesPaths.femaleProfile,
    );
  }
}
