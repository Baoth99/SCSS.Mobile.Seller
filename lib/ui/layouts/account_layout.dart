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
            FunctionalWidgets.showCustomDialog(context);
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
        avatar(context),
        options(context),
      ],
    );
  }

  Widget avatar(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 500.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment
              .bottomCenter, // 10% of the width, so there are ten blinds.
          colors: <Color>[
            AppColors.greenFF61C53D.withOpacity(0.7),
            AppColors.greenFF39AC8F.withOpacity(0.7),
          ], // red to yellow
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      child: Row(
        children: [
          Container(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (p, c) =>
                  (p.imageProfile != c.imageProfile) || p.gender != c.gender,
              builder: (context, state) {
                return AvatarWidget(
                  image: state.imageProfile,
                  isMale: state.gender == Gender.male,
                  width: 250,
                );
              },
            ),
            margin: EdgeInsets.only(
                left: 70.w, top: 170.h, right: 40.w, bottom: 40.h),
          ),
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: CustomText(
                      text: state.name,
                      color: AppColors.white,
                      fontSize: 70.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    margin:
                        EdgeInsets.only(top: 170.h, right: 80.w, bottom: 20.h),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10.w),
                        child: Icon(
                          Icons.control_point_duplicate_outlined,
                          color: Colors.amber,
                          size: 50.sp,
                        ),
                      ),
                      CustomText(
                        text: '${state.totalPoint}',
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.white,
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ],
      ),
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
                'Thông tin tài khoản',
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
      height: 180.h,
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
              left: 80.w,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CustomText(
                    text: name,
                    color: color,
                    fontSize: 45.sp,
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
