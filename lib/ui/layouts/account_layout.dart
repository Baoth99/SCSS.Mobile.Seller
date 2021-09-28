import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/blocs/account_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/avartar_widget.dart';
import 'package:seller_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:formz/formz.dart';

class AccountLayout extends StatelessWidget {
  const AccountLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AccountBloc>(
      create: (context) => AccountBloc(),
      child: BlocListener<AccountBloc, AccountState>(
        listener: (context, state) {
          if (state.status.isSubmissionInProgress) {
            showDialog(
              context: context,
              builder: (context) => const CustomProgressIndicatorDialog(
                text: 'Xin vui lòng đợi',
              ),
            );
          }
          if (state.status.isSubmissionFailure) {
            // Navigator.of(context).popUntil(
            //   ModalRoute.withName(Routes.main),
            // );

            //in case of fail
            Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.login, (Route<dynamic> route) => false);
          }

          if (state.status.isSubmissionSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                Routes.login, (Route<dynamic> route) => false);
          }
        },
        child: const Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0XFFF8F8F8),
          body: AccountBody(),
        ),
      ),
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
      height: 550.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment
              .bottomCenter, // 10% of the width, so there are ten blinds.
          colors: <Color>[
            AppColors.greenFF61C53D.withOpacity(0.5),
            AppColors.greenFF39AC8F.withOpacity(0.5),
          ], // red to yellow
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      child: Row(
        children: [
          Container(
            child: AvatarWidget(
              imagePath:
                  'https://post.medicalnewstoday.com/wp-content/uploads/sites/3/2020/02/322868_1100-800x825.jpg',
              isMale: false,
              width: 250,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 50.w,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                    color: Colors.white70,
                  ),
                  Container(
                    child: Icon(
                      Icons.fiber_manual_record,
                      color: Colors.white70,
                      size: 20.sp,
                    ),
                    margin: EdgeInsets.symmetric(
                      horizontal: 25.w,
                    ),
                  ),
                  const CustomText(
                    text: '+84767234215',
                    color: Colors.white70,
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget options(BuildContext context) {
    return Container(
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
            () {
              context.read<AccountBloc>().add(LogoutEvent());
            },
            Colors.red,
            Icons.logout_outlined,
          ),
        ],
      ),
    );
  }

  Widget option(String name, void Function() onPressed, Color color,
      [IconData? iconData]) {
    return Container(
      color: Colors.white70,
      height: 140.h,
      margin: EdgeInsets.symmetric(
        vertical: 3.h,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            margin: EdgeInsets.only(
              right: 40.w,
              left: 60.w,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: name,
                    color: color,
                    fontSize: 40.sp,
                  ),
                ),
                Icon(
                  iconData,
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
