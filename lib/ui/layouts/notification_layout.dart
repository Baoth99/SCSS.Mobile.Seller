import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:seller_app/blocs/notification_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/layouts/request_detail_layout.dart';
import 'package:seller_app/ui/widgets/common_margin_container.dart';
import 'package:seller_app/ui/widgets/common_scaffold_title.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';

class NotificationLayout extends StatelessWidget {
  const NotificationLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<NotificationBloc>().add(NotificationInitial());
    return Scaffold(
      appBar: AppBar(
        title: const CommonScaffoldTitle('Thông báo'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: CommonMarginContainer(
        child: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            return state.screenStatus.isSubmissionSuccess
                ? NotificationBody()
                : state.screenStatus.isSubmissionInProgress
                    ? FunctionalWidgets.getLoadingAnimation()
                    : const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class NotificationBody extends StatefulWidget {
  NotificationBody({Key? key}) : super(key: key);

  @override
  _NotificationBodyState createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody> {
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
    return BlocListener<NotificationBloc, NotificationState>(
      listener: (context, state) {
        if (state.refreshStatus == RefreshStatus.completed) {
          _refreshController.refreshCompleted();
        }
        if (state.loadStatus == LoadStatus.idle) {
          _refreshController.loadComplete();
        }
      },
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
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
            child: state.listNotificationData.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.only(
                      top: kFloatingActionButtonMargin + 5.h,
                      bottom: kFloatingActionButtonMargin + 48.h,
                    ),
                    itemBuilder: (context, index) {
                      return NotificationElement(
                        state.listNotificationData[index].id,
                        state.listNotificationData[index].isRead,
                        state.listNotificationData[index].title,
                        state.listNotificationData[index].body,
                        state.listNotificationData[index].time,
                        index,
                        state.listNotificationData[index].screenId,
                        state.listNotificationData[index].screenDataId,
                      );
                    },
                    separatorBuilder: (context, index) => _divider(),
                    itemCount: state.listNotificationData.length,
                  )
                : _emptyList(),
          );
        },
      ),
    );
  }

  void Function() _onLoading(BuildContext context) {
    return () {
      context.read<NotificationBloc>().add(NotificationLoading());
    };
  }

  void Function() _onRefresh(BuildContext context) {
    return () {
      context.read<NotificationBloc>().add(NotificationRefresh());
    };
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

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: Divider(
        thickness: 6.h,
      ),
    );
  }
}

class NotificationElement extends StatefulWidget {
  NotificationElement(
    this.id,
    this.isRead,
    this.title,
    this.content,
    this.time,
    this.index,
    this.screenId,
    this.screenDataId, {
    Key? key,
  }) : super(key: key);

  final String id;
  final bool isRead;
  final String title;
  final String content;
  final String time;
  final int index;
  final int? screenId;
  final String? screenDataId;

  @override
  _NotificationElementState createState() => _NotificationElementState();
}

class _NotificationElementState extends State<NotificationElement> {
  bool isRead = false;
  @override
  void initState() {
    super.initState();
    isRead = widget.isRead;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.read<NotificationBloc>().add(
              NotificationRead(widget.id, widget.index),
            );

        setState(() {
          isRead = true;
        });

        if (widget.screenId != null) {
          switch (widget.screenId) {
            case 1:
              Navigator.pushNamed(
                context,
                Routes.requestDetail,
                arguments:
                    RequestDetailArguments(requestId: widget.screenDataId!),
              );
              break;
            default:
          }
        }
      },
      child: IntrinsicHeight(
        child: Row(
          children: [
            Icon(
              isRead ? Icons.drafts_outlined : Icons.email_outlined,
            ),
            Container(
              child: const VerticalDivider(color: Colors.black, width: 20),
              margin: EdgeInsets.symmetric(
                horizontal: 20.w,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: widget.title,
                    fontSize: 45.sp,
                    color: isRead ? AppColors.black : AppColors.greenFF61C53D,
                    fontWeight: FontWeight.w500,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: 12.h,
                    ),
                    child: CustomText(
                      text: widget.content,
                      color: Colors.grey[700],
                    ),
                  ),
                  CustomText(
                    text: widget.time,
                    fontSize: 34.sp,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
