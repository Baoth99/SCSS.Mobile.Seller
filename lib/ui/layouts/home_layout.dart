import 'package:flutter/material.dart';
import 'package:seller_app/blocs/main_bloc.dart';
import 'package:seller_app/blocs/models/gender_model.dart';
import 'package:seller_app/blocs/profile_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/avartar_widget.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key, required this.tabController}) : super(key: key);
  TabController tabController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AccountBody(
        tabController: tabController,
      ),
    );
  }
}

class AccountBody extends StatelessWidget {
  const AccountBody({Key? key, required this.tabController}) : super(key: key);
  final TabController tabController;
  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(ProfileInitial());
    return Column(
      children: [
        avatar(context),
        waitToCollect(context),
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
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          return Row(
            children: [
              Container(
                child: AvatarWidget(
                  image: state.imageProfile,
                  isMale: state.gender == Gender.male,
                  width: 250,
                ),
                margin: EdgeInsets.only(
                    left: 70.w, top: 170.h, right: 40.w, bottom: 40.h),
              ),
              Column(
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
              ),
            ],
          );
        },
      ),
    );
  }

  Widget waitToCollect(BuildContext context) {
    return Material(
      elevation: 1,
      child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
          ),
          child: Column(children: [
            Row(children: [
              Container(
                padding: EdgeInsets.only(top: 30.h, left: 45.w),
                child: CustomText(
                  text: 'Yêu cầu thu gom đã xác nhận',
                  fontSize: 45.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Expanded(
                  child: CollectingRequest(
                    bookingId: 'SC00000001',
                    bulky: false,
                    time: 'Th 4, 25/08/2021  10:00 - 12:00',
                    placeTitle: 'EJ Sporting House',
                    placeName: 'Lô D chung cư Nguyễn Trãi, phường 8, quận 5',
                  ),
                )
              ],
            ),
            InkWell(
              onTap: () {
                context.read<MainBloc>().add(
                      const MainBarItemTapped(MainLayoutConstants.activity),
                    );

                tabController.animateTo(1);
              },
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      child: CustomText(
                        text: 'Xem tất cả yêu cầu',
                        fontSize: 45.sp,
                        fontWeight: FontWeight.w500,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 30.w, bottom: 20.h),
                    child: Icon(
                      Icons.chevron_right,
                      color: AppColors.greyFF9098B1,
                      size: 80.sp,
                    ),
                  )
                ],
              ),
            )
          ])),
    );
  }
}

class CollectingRequest extends StatelessWidget {
  const CollectingRequest({
    Key? key,
    required this.bookingId,
    required this.time,
    required this.placeTitle,
    required this.placeName,
    required this.bulky,
  }) : super(key: key);

  final String bookingId;
  final String time;
  final String placeTitle;
  final String placeName;
  final bool bulky;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 35.h, horizontal: 100.w),
      constraints: BoxConstraints(
        minHeight: 130.h,
      ),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30.0.r),
          boxShadow: [
            const BoxShadow(
              color: AppColors.greyFFDADADA,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ]),
      child: InkWell(
        onTap: _onTapRequestWaitToCollect(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0.r),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                  ),
                  decoration: BoxDecoration(
                    color: bulky
                        ? AppColors.orangeFFF9CB79
                        : AppColors.greenFF66D095,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        bulky
                            ? ActivityLayoutConstants.bulkyImage
                            : ActivityLayoutConstants.notBulkyImage,
                        width: 90.w,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    constraints: BoxConstraints(minHeight: 130.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getContainerColumn(
                          CustomText(
                            text: time,
                            color: Colors.green[600],
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _getContainerColumn(
                          CustomText(
                            text: placeTitle,
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _getContainerColumn(
                          CustomText(
                            text: placeName,
                            fontSize: 38.sp,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // isCompleted != null && isCompleted!
                //     ? Container(
                //   // constraints: BoxConstraints(
                //   //   minWidth: 100.w,
                //   // ),
                //   width: 270.w,
                //   child: CustomText(
                //     text: extraInfo ?? Symbols.empty,
                //     color: isCompleted!
                //         ? Colors.green[600]
                //         : AppColors.orangeFFF5670A,
                //     fontWeight: FontWeight.w500,
                //   ),
                //   alignment: Alignment.center,
                // )
                //     : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void Function() _onTapRequestWaitToCollect(BuildContext context) {
    return () {};
  }

  Widget _getContainerColumn(Widget child) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: child,
    );
  }
}
