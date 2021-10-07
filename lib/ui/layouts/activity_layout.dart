import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seller_app/blocs/activity_list_bloc.dart';
import 'package:seller_app/blocs/main_bloc.dart';
import 'package:seller_app/constants/constants.dart';
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
    super.dispose();
    _refreshController.dispose();
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
            body = Text("Kéo lên để tải thêm thông tin");
          } else if (mode == LoadStatus.loading) {
            body = const CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          } else {
            body = Text("No more Data");
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
  final bool bulky;
  final int privateStatus;
  final int tabStatus;
  final String? price;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      constraints: BoxConstraints(
        minHeight: 200.h,
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            text: '$time, $fromTime-$toTime',
                            color: Colors.green[600],
                            fontSize: 37.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        privateStatus == ActivityLayoutConstants.completed &&
                                price != null
                            ? _getContainerColumn(
                                CustomText(
                                  text: 'Tổng cộng: $price ₫',
                                  fontSize: 40.sp,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
                tabStatus == ActivityLayoutConstants.tabCompleted
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
                          text: _getCompletedText(privateStatus),
                          color: _getCompletedColor(privateStatus),
                          fontWeight: FontWeight.w500,
                          fontSize: 36.sp,
                        ),
                        alignment: Alignment.topRight)
                    : const SizedBox.shrink(),
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
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: child,
    );
  }
}
