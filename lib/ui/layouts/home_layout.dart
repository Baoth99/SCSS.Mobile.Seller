import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seller_app/blocs/home_bloc.dart';
import 'package:seller_app/blocs/main_bloc.dart';
import 'package:seller_app/blocs/models/gender_model.dart';
import 'package:seller_app/blocs/profile_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/log/logger.dart';
import 'package:seller_app/ui/layouts/request_detail_layout.dart';
import 'package:seller_app/ui/widgets/avartar_widget.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key, required this.tabController}) : super(key: key);
  TabController tabController;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeInitial()),
      child: Scaffold(
        body: AccountBody(
          tabController: tabController,
        ),
      ),
    );
  }
}

class AccountBody extends StatefulWidget {
  const AccountBody({Key? key, required this.tabController}) : super(key: key);
  final TabController tabController;

  @override
  _AccountBodyState createState() => _AccountBodyState();
}

class _AccountBodyState extends State<AccountBody> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    try {
      _timer = Timer.periodic(
        const Duration(seconds: 60),
        (timer) {
          try {
            context.read<HomeBloc>().add(HomeFetch());
          } catch (e) {
            AppLog.error(e);
          }
        },
      );
    } catch (e) {
      AppLog.error(e);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

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
                      fontSize: 60.sp,
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

  Widget waitToCollect(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Material(
          elevation: 1,
          child: Container(
            constraints: BoxConstraints(minHeight: 500.h),
            decoration: const BoxDecoration(
              color: AppColors.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          context.read<MainBloc>().add(
                                const MainBarItemTapped(
                                    MainLayoutConstants.activity),
                              );

                          widget.tabController.animateTo(1);
                        },
                        child: Container(
                          padding: EdgeInsets.only(top: 30.h, left: 45.w),
                          child: CustomText(
                            text: 'Yêu cầu thu gom đã xác nhận',
                            fontSize: 45.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    state.status.isSubmissionInProgress
                        ? const SizedBox.shrink()
                        : IconButton(
                            onPressed: () {
                              context.read<HomeBloc>().add(HomeInitial());
                            },
                            icon: const Icon(
                              Icons.replay,
                              color: AppColors.greyFF9098B1,
                            ),
                          ),
                  ],
                ),
                state.status.isSubmissionSuccess
                    ? Column(
                        children: [
                          getNearestApprovedRequest(context, state),
                          getSeeAllButton(context, state),
                        ],
                      )
                    : (state.status.isSubmissionInProgress ||
                            state.status.isPure)
                        ? FunctionalWidgets.getLoadingAnimation()
                        : FunctionalWidgets.getErrorIcon(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget getNearestApprovedRequest(BuildContext context, HomeState state) {
    var a = state.activity;
    if (a != null) {
      try {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: CollectingRequest(
                bookingId: a.collectingRequestId,
                bulky: a.isBulky,
                time: '${a.collectingRequestDate}, ${a.fromTime}-${a.toTime}',
                placeTitle: a.addressName,
                placeName: a.address,
              ),
            )
          ],
        );
      } catch (e) {
        AppLog.error(e);
        return _getEmptyActivity();
      }
    } else {
      return _getEmptyActivity();
    }
  }

  Widget getSeeAllButton(BuildContext context, HomeState state) {
    return state.activity != null
        ? InkWell(
            onTap: () {
              context.read<MainBloc>().add(
                    const MainBarItemTapped(MainLayoutConstants.activity),
                  );

              widget.tabController.animateTo(1);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 30.h,
                horizontal: 200.w,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 70.w,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 20.h),
                    child: CustomText(
                      text: 'Xem tất cả',
                      fontSize: 45.sp,
                      fontWeight: FontWeight.w500,
                      textAlign: TextAlign.center,
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
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _getEmptyActivity() {
    return Column(
      children: [
        SizedBox(
          height: 200.h,
        ),
        Image.asset(
          ImagesPaths.emptyActivityList,
          height: 200.h,
        ),
        Container(
          child: CustomText(
            text: 'Chưa có yêu cầu',
            fontSize: 40.sp,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
            textAlign: TextAlign.center,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 100.w,
            vertical: 50.w,
          ),
        ),
      ],
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
        minHeight: 300.h,
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
        onTap: () {
          Navigator.of(context).pushNamed(
            Routes.requestDetail,
            arguments: RequestDetailArguments(requestId: bookingId),
          );
        },
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
                            fontSize: 39.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _getContainerColumn(
                          CustomText(
                            text: placeTitle,
                            fontSize: 43.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _getContainerColumn(
                          CustomText(
                            text: placeName,
                            fontSize: 40.sp,
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

  Widget _getContainerColumn(Widget child) {
    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 30.w),
      child: child,
    );
  }
}
