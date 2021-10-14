import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/blocs/account_bloc.dart';
import 'package:seller_app/blocs/models/gender_model.dart';
import 'package:seller_app/blocs/profile_bloc.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/layouts/layouts.dart';
import 'package:seller_app/ui/widgets/avartar_widget.dart';
import 'package:seller_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:seller_app/utils/common_utils.dart';

class AccountLayout extends StatelessWidget {
  const AccountLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(ProfileInitial());
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
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Color(0XFFF8F8F8),
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, s) {
              return s.status.isSubmissionSuccess ||
                      s.status.isSubmissionFailure
                  ? const AccountBody()
                  : FunctionalWidgets.getLoadingAnimation();
            },
          ),
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
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, s) {
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
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
          child: Row(
            children: [
              Container(
                child: _getAvatarFutureBuilder(
                  s.gender,
                  s.imageProfile,
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
                      text: s.name,
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
                      Icon(
                        Icons.control_point_duplicate_outlined,
                        color: Colors.yellow,
                        size: 47.sp,
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                      CustomText(
                        text: s.totalPoint.toString(),
                        color: Colors.white70,
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w600,
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
                      CustomText(
                        text: s.phone,
                        color: Colors.white70,
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getAvatarFutureBuilder(Gender gender, ImageProvider<Object>? image) {
    return AvatarWidget(
      image: image,
      isMale: gender == Gender.male,
      width: 250,
    );
  }

  Widget options(BuildContext context) {
    return Container(
      child: Column(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, s) {
              return option(
                'Chỉnh sửa hồ sơ',
                () {
                  Navigator.of(context)
                      .pushNamed(
                    Routes.profileEdit,
                    arguments: ProfileEditArgs(
                      name: s.name,
                      imagePath: s.image,
                      phoneNumber: s.phone,
                      address: s.address ?? Symbols.empty,
                      email: s.email ?? Symbols.empty,
                      gender: s.gender,
                      birthdate: s.birthDate,
                    ),
                  )
                      .then((value) {
                    context.read<ProfileBloc>().add(ProfileInitial());
                  });
                },
                Colors.black,
                Icons.arrow_forward_ios,
              );
            },
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return option(
                'Đổi mật khẩu',
                () {
                  Navigator.of(context).pushNamed(Routes.profilePasswordEdit,
                      arguments: ProfilePasswordEditArgs(state.id));
                },
                Colors.black,
                Icons.arrow_forward_ios,
              );
            },
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
