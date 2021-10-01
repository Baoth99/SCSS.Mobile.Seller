import 'package:flutter/material.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/common_margin_container.dart';
import 'package:seller_app/ui/widgets/common_scaffold_title.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'request_detail_layout.dart';

class ActivityLayout extends StatelessWidget {
  const ActivityLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // The number of tabs / content sections to display.

      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const CommonScaffoldTitle('Hoạt động của tôi'),
          bottom: TabBar(
            indicatorColor: Colors.green[600],
            isScrollable: true,
            labelColor: Colors.green[600],
            labelStyle: TextStyle(
              fontSize: 44.sp,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelColor: Colors.grey[600],
            tabs: [
              const Tab(
                text: 'Yêu cầu thu gom',
              ),
              const Tab(
                text: 'Xác nhận thu gom',
              ),
              const Tab(
                text: 'Lịch sử',
              ),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: const TabBarView(
          children: [
            CommonMarginContainer(
              child: ActivityList(),
            ),
            CommonMarginContainer(
              child: ActivityList(),
            ),
            CommonMarginContainer(
              child: ActivityList(),
            ),
          ],
        ),
      ), // Complete this code in the next step.
    );
  }
}

class ActivityList extends StatelessWidget {
  const ActivityList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => CurrentActivity(
        requestId: 'suck may dick',
        time: 'Th3, 24 thg8, 2021, 09:45 - 10:00',
        placeName: 'Công viên tao đàng',
        bulky: true,
        isCompleted: true,
        extraInfo: 'Hoàn thành',
        price: '500.000đ',
      ),
      separatorBuilder: (context, index) => Container(),
      itemCount: 20,
    );
  }
}

class CurrentActivity extends StatelessWidget {
  const CurrentActivity({
    Key? key,
    required this.requestId,
    required this.time,
    required this.placeName,
    required this.bulky,
    this.isCompleted,
    this.extraInfo,
    this.price,
  }) : super(key: key);

  final String requestId;
  final String time;
  final String placeName;
  final bool bulky;
  final bool? isCompleted;
  final String? extraInfo;
  final String? price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      constraints: BoxConstraints(
        minHeight: 130.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(30.0.r),
      ),
      child: InkWell(
        onTap: _onTap(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0.r),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 25.w,
                  ),
                  child: Image.asset(
                    bulky
                        ? ActivityLayoutConstants.bulkyImage
                        : ActivityLayoutConstants.notBulkyImage,
                    width: 65.w,
                  ),
                  decoration: BoxDecoration(
                    color: bulky
                        ? AppColors.yellowFFF3F09A
                        : AppColors.greenFF66D095,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 20.w,
                    ),
                    constraints: BoxConstraints(minHeight: 130.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _getContainerColumn(
                          CustomText(
                            text: placeName,
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _getContainerColumn(
                          CustomText(
                            text: time,
                            color: Colors.green[600],
                            fontSize: 37.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        price != null
                            ? _getContainerColumn(
                                CustomText(
                                  text: 'Tổng cộng: $price',
                                  fontSize: 40.sp,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                isCompleted != null && isCompleted!
                    ? Container(
                        // constraints: BoxConstraints(
                        //   minWidth: 100.w,
                        // ),
                        padding: EdgeInsets.only(
                          top: 15.h,
                          right: 20.w,
                        ),
                        width: 200.w,
                        child: CustomText(
                          text: extraInfo ?? Symbols.empty,
                          color: isCompleted!
                              ? Colors.green[600]
                              : AppColors.orangeFFF5670A,
                          fontWeight: FontWeight.w500,
                          fontSize: 30.sp,
                        ),
                        alignment: Alignment.topRight)
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void Function() _onTap(BuildContext context) {
    return () {
      Navigator.of(context).pushNamed(
        Routes.requestDetail,
        arguments: RequestDetailArguments(requestId: requestId),
      );
    };
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
