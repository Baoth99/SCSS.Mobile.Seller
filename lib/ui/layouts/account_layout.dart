import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/avartar_widget.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';

class AccountLayout extends StatelessWidget {
  const AccountLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[300],
      body: const AccountBody(),
    );
  }
}

class AccountBody extends StatelessWidget {
  const AccountBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        avatar(),
        options(context),
      ],
    );
  }

  Widget avatar() {
    return Container(
      width: double.infinity,
      height: 900.h,
      color: AppColors.greenFF61C53D.withOpacity(0.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarWidget(
            imagePath:
                'https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg',
            isMale: false,
          ),
          Container(
            child: CustomText(
              text: 'Vũ Xuân Thiên',
              color: Colors.white70,
              fontSize: 55.sp,
              fontWeight: FontWeight.w500,
            ),
            margin: EdgeInsets.symmetric(
              vertical: 20.h,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
              ),
              CustomText(
                text: '56',
                fontSize: 50.sp,
                fontWeight: FontWeight.w500,
              ),
              Container(
                child: Icon(
                  Icons.fiber_manual_record,
                  color: Colors.black,
                  size: 20.sp,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 25.w,
                ),
              ),
              const CustomText(text: '+84767234215'),
            ],
          )
        ],
      ),
    );
  }

  Widget options(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 30.h,
      ),
      child: Column(
        children: [
          option(
            'Chỉnh sửa hồ sơ',
            () {
              Navigator.of(context).pushNamed(
                Routes.profileEdit,
              );
            },
            Colors.black,
            Icons.arrow_forward_ios,
          ),
          option(
            'Đổi mật khẩu',
            () {
              Navigator.of(context).pushNamed(
                Routes.profilePasswordEdit,
              );
            },
            Colors.black,
            Icons.arrow_forward_ios,
          ),
          option(
            'Đăng xuất',
            () {},
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget option(String name, void Function() onPressed, Color color,
      [IconData? iconData]) {
    return Container(
      color: Colors.white70,
      height: 130.h,
      margin: EdgeInsets.symmetric(
        vertical: 7.h,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 40.w,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: name,
                    color: color,
                    fontSize: 49.sp,
                  ),
                ),
                Icon(iconData),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
