import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seller_app/blocs/activity_list_bloc.dart';
import 'package:seller_app/blocs/main_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/log/logger.dart';
import 'package:seller_app/ui/widgets/common_margin_container.dart';
import 'package:seller_app/ui/widgets/common_scaffold_title.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'request_detail_layout.dart';

class ActivityLayout extends StatelessWidget {
  const ActivityLayout({
    Key? key,
    required this.controller,
  }) : super(key: key);
  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonScaffoldTitle('Hoạt động của tôi'),
        elevation: 1,
        bottom: TabBar(
          controller: controller,
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
          // onTap: (value) {
          //
          // },
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: TabBarView(
        controller: controller,
        children: [
          const CommonMarginContainer(
            child: ActivityList(
              status: ActivityLayoutConstants.tabPending,
            ),
          ),
          const CommonMarginContainer(
            child: ActivityList(status: ActivityLayoutConstants.tabApproved),
          ),
          const CommonMarginContainer(
            child: ActivityList(
              status: ActivityLayoutConstants.tabCompleted,
            ),
          ),
        ],
      ),
      // Complete this code in the next step.
    );
  }
}

class ActivityList extends StatelessWidget {
  const ActivityList({
    Key? key,
    required this.status,
  }) : super(key: key);

  final int status;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityListBloc(
        status: status,
      )..add(
          ActivityListInitial(),
        ),
      child: BlocBuilder<ActivityListBloc, ActivityListState>(
        builder: (context, state) => _buildScreen(context, state),
      ),
    );
  }

  Widget _buildScreen(
    BuildContext context,
    ActivityListState state,
  ) {
    try {
      switch (state.status) {
        case ActivityListStatus.completed:
          return ActivityListData(
            tabStatus: status,
          );
        case ActivityListStatus.progress:
          return FunctionalWidgets.getLoadingAnimation();
        case ActivityListStatus.error:
          return FunctionalWidgets.getErrorIcon();
        default:
          return const SizedBox.shrink();
      }
    } catch (e) {
      AppLog.error(e);
      return FunctionalWidgets.getErrorIcon();
    }
  }
}

class ActivityListData extends StatefulWidget {
  const ActivityListData({
    Key? key,
    required this.tabStatus,
  }) : super(key: key);
  final int tabStatus;
  @override
  _ActivityListDataState createState() => _ActivityListDataState();
}

class _ActivityListDataState extends State<ActivityListData> {
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityListBloc, ActivityListState>(
      builder: (context, state) =>
          BlocListener<ActivityListBloc, ActivityListState>(
        listener: (context, state) {
          if (state.refreshStatus == RefreshStatus.completed) {
            _refreshController.refreshCompleted();
          }
          if (state.loadStatus == LoadStatus.idle) {
            _refreshController.loadComplete();
          }
        },
        child: _buildCommonPullToResfresh(
            context, state, state.listActivity.isNotEmpty),
      ),
    );
  }

  Widget _emptyList() {
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

  Widget _buildCommonPullToResfresh(
      BuildContext context, ActivityListState state, bool isNotEmpty) {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: const WaterDropHeader(
        waterDropColor: AppColors.greenFF61C53D,
        failed: SizedBox.shrink(),
        complete: SizedBox.shrink(),
      ),
      footer: CustomFooter(
        builder: (context, mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("");
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("");
          } else {
            body = Text("");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh(context),
      onLoading: _onLoading(context),
      child: isNotEmpty
          ? ListView.separated(
              padding: EdgeInsets.only(
                top: kFloatingActionButtonMargin + 5.h,
                bottom: kFloatingActionButtonMargin + 48.h,
              ),
              itemBuilder: (context, index) => _buildActivity(
                state,
                index,
                widget.tabStatus,
              ),
              separatorBuilder: (context, index) => const SizedBox.shrink(),
              itemCount: state.listActivity.length,
            )
          : _emptyList(),
    );
  }

  void Function() _onLoading(BuildContext context) {
    return () {
      context.read<ActivityListBloc>().add(ActivityListLoading());
    };
  }

  void Function() _onRefresh(BuildContext context) {
    return () {
      context.read<ActivityListBloc>().add(ActivityListRefresh());
    };
  }

  Widget _buildActivity(
    ActivityListState state,
    int index,
    int tabStatus,
  ) {
    var a = state.listActivity[index];
    return CurrentActivity(
      requestId: a.collectingRequestId,
      time: a.collectingRequestDate,
      fromTime: a.fromTime,
      toTime: a.toTime,
      placeName: a.addressName,
      address: a.address,
      bulky: a.isBulky,
      privateStatus: a.status,
      tabStatus: tabStatus,
      price: a.total,
    );
  }
}

class CurrentActivity extends StatelessWidget {
  const CurrentActivity({
    Key? key,
    required this.requestId,
    required this.time,
    required this.fromTime,
    required this.toTime,
    required this.placeName,
    required this.address,
    required this.bulky,
    required this.privateStatus,
    required this.tabStatus,
    this.price,
  }) : super(key: key);

  final String requestId;
  final String time;
  final String fromTime;
  final String toTime;
  final String placeName;
  final String address;
  final bool bulky;
  final int privateStatus;
  final int tabStatus;
  final int? price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 35.h,
      horizontal: 25.w),
      constraints: BoxConstraints(
        minHeight: 300.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          const BoxShadow(
            color: AppColors.greyFFDADADA,
            blurRadius: 2.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
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
                    horizontal: 30.w,
                  ),
                  child: Image.asset(
                    bulky
                        ? ActivityLayoutConstants.bulkyImage
                        : ActivityLayoutConstants.notBulkyImage,
                    width: 90.w,
                  ),
                  decoration: BoxDecoration(
                    color: bulky
                        ? AppColors.orangeFFF9CB79
                        : AppColors.greenFF66D095,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                    constraints: BoxConstraints(minHeight: 130.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _getContainerColumn(
                                CustomText(
                                  text: '$time, $fromTime-$toTime',
                                  color: Colors.green[600],
                                  fontSize: 39.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            tabStatus == ActivityLayoutConstants.tabCompleted
                                ? Container(
                              // constraints: BoxConstraints(
                              //   minWidth: 100.w,
                              // ),
                              //   padding: EdgeInsets.only(
                              //     top: 15.h,
                              //     right: 20.w,
                              //   ),
                                width: 210.w,
                                child: CustomText(
                                  text: _getCompletedText(privateStatus),
                                  color: _getCompletedColor(privateStatus),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 39.sp,
                                ),
                                alignment: Alignment.topRight)
                                : const SizedBox.shrink(),
                          ],
                        ),
                        _getContainerColumn(
                          CustomText(
                            text: placeName,
                            fontSize: 43.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _getContainerColumn(
                          CustomText(
                            text: address,
                            fontSize: 40.sp,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        privateStatus == ActivityLayoutConstants.completed &&
                                price != null
                            ? _getContainerColumn(
                                CustomText(
                                  text: 'Tổng cộng: $price ₫',
                                  fontSize: 40.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green[600],
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getCompletedText(int status) {
    switch (status) {
      case ActivityLayoutConstants.completed:
        return 'Hoàn thành';
      case ActivityLayoutConstants.cancelBySeller:
        return 'Đã hủy';
      case ActivityLayoutConstants.cancelByCollect:
      case ActivityLayoutConstants.cancelBySystem:
        return 'Bị hủy';
      default:
        return Symbols.empty;
    }
  }

  Color _getCompletedColor(int status) {
    switch (status) {
      case ActivityLayoutConstants.completed:
        return Colors.green[600]!;
      case ActivityLayoutConstants.cancelBySeller:
      case ActivityLayoutConstants.cancelByCollect:
      case ActivityLayoutConstants.cancelBySystem:
        return AppColors.orangeFFF5670A;
      default:
        return Colors.black;
    }
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
      margin: EdgeInsets.only(
        top: 10.h,
        bottom: 10.h,
        right: 30.w
      ),
      child: child,
    );
  }
}
