import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dotted_line/dotted_line.dart';
// import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_app/blocs/cancel_request_bloc.dart';
import 'package:seller_app/blocs/feedback_admin_bloc.dart';
import 'package:seller_app/blocs/feedback_transaction_bloc.dart';
import 'package:seller_app/blocs/request_detail_bloc.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/log/logger.dart';
import 'package:seller_app/ui/widgets/common_margin_container.dart';
import 'package:seller_app/ui/widgets/custom_progress_indicator_dialog_widget.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:formz/formz.dart';
import 'package:seller_app/ui/widgets/radiant_gradient_mask.dart';
import 'package:seller_app/ui/widgets/view_image_layout.dart';
import 'package:seller_app/utils/common_utils.dart';
import 'package:seller_app/utils/extension_methods.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestDetailArguments {
  final String requestId;
  const RequestDetailArguments({
    required this.requestId,
  });
}

class RequestDetailLayout extends StatelessWidget {
  const RequestDetailLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RequestDetailArguments;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        title: CustomText(
          text: 'Yêu cầu thu gom',
          color: AppColors.white,
          fontSize: 50.sp,
        ),
        color: AppColors.white,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment
                  .centerLeft, // 10% of the width, so there are ten blinds.
              colors: <Color>[
                AppColors.greenFF61C53D.withOpacity(0.5),
                AppColors.greenFF39AC8F.withOpacity(0.5),
              ], // red to yellow
              tileMode:
                  TileMode.repeated, // repeats the gradient over the canvas
            ),
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => RequestDetailBloc(id: args.requestId)
          ..add(
            RequestDetailInitial(),
          ),
        child: BlocBuilder<RequestDetailBloc, RequestDetailState>(
          builder: (context, state) => state.stateStatus.isSubmissionInProgress
              ? FunctionalWidgets.getLoadingAnimation()
              : state.stateStatus.isSubmissionSuccess
                  ? _body(context)
                  : state.stateStatus.isSubmissionFailure
                      ? Center(
                          child: FunctionalWidgets.getErrorIcon(),
                        )
                      : const SizedBox.shrink(),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    return BlocBuilder<RequestDetailBloc, RequestDetailState>(
      builder: (c, s) => ListView(
        padding: EdgeInsets.only(
          top: kFloatingActionButtonMargin + 5.h,
          bottom: kFloatingActionButtonMargin + 48.h,
        ),
        children: [
          const RequestDetailHeader(),
          s.status == ActivityLayoutConstants.completed &&
                  (s.feedbackStatus == FeedbackStatus.haveGivenFeedback ||
                      s.feedbackStatus ==
                          FeedbackStatus.haveNotGivenFeedbackYet)
              ? Column(
                  children: [
                    const RequestDetailDivider(),
                    const RequestDetailRating(),
                  ],
                )
              : const SizedBox.shrink(),
          s.collectorName.isNotEmpty &&
                  s.collectorPhoneNumber.isNotEmpty &&
                  (s.status != ActivityLayoutConstants.pending)
              ? Column(
                  children: [
                    const RequestDetailDivider(),
                    const RequestDetailCollectorInfo(),
                  ],
                )
              : const SizedBox.shrink(),
          const RequestDetailDivider(),
          const RequestDetailBody(),
          s.status == ActivityLayoutConstants.completed
              ? Column(
                  children: [
                    const RequestDetailDivider(),
                    const RequestDetailBill(),
                  ],
                )
              : const SizedBox.shrink(),
          const RequestDetailDivider(),
          const RequestDetailTime(),
          s.isCancelable ? _getCancelButton(context) : const SizedBox.shrink(),
          s.complaint.complaintStatus ==
                      FeedbackToSystemStatus.canGiveFeedback ||
                  s.complaint.complaintStatus ==
                      FeedbackToSystemStatus.haveGivenFeedback ||
                  s.complaint.complaintStatus ==
                      FeedbackToSystemStatus.adminReplied
              ? _getFeedbackToAdmin(context)
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _getFeedbackToAdmin(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerRight,
      margin: EdgeInsets.only(
        top: 40.h,
      ),
      child: CommonMarginContainer(
        child: BlocBuilder<RequestDetailBloc, RequestDetailState>(
          builder: (context, state) {
            return TextButton(
              onPressed: _feedbackAdminPressed(
                context,
                state.complaint.complaintStatus,
                state.complaint.complaintContent,
                state.complaint.adminReply,
                state.id,
              ),
              child: const CustomText(
                text: 'Phản hồi',
                color: AppColors.orangeFFF5670A,
              ),
              style: TextButton.styleFrom(
                primary: AppColors.orangeFFF5670A,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getCancelButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: 40.h,
        top: 40.h,
      ),
      child: BlocBuilder<RequestDetailBloc, RequestDetailState>(
        builder: (context, state) {
          return CommonMarginContainer(
            child: ElevatedButton(
              onPressed: _cancelPressed(context, state.id),
              style: ElevatedButton.styleFrom(
                primary: AppColors.orangeFFF5670A,
                minimumSize: Size(
                  double.infinity,
                  WidgetConstants.buttonCommonHeight.h,
                ),
              ),
              child: CustomText(
                text: 'Hủy đơn hẹn',
                fontSize: WidgetConstants.buttonCommonFrontSize.sp,
                fontWeight: WidgetConstants.buttonCommonFrontWeight,
              ),
            ),
          );
        },
      ),
    );
  }

  void Function() _feedbackAdminPressed(
    BuildContext context,
    int status,
    String? sellingFeedback,
    String? replyAdmin,
    String requestId,
  ) {
    return () {
      FunctionalWidgets.showCustomModalBottomSheet(
        context: context,
        child: _getFeedbackAdminWidget(
          status,
          sellingFeedback,
          replyAdmin,
          requestId,
        ),
        title: 'Phản hồi',
        routeClosed: Routes.requestDetail,
      ).then((value) {
        if (value != null && value) {
          context.read<RequestDetailBloc>().add(RequestDetailInitial());
        }
      });
    };
  }

  Widget _getFeedbackAdminWidget(
    int status,
    String? sellingFeedback,
    String? replyAdmin,
    String requestId,
  ) {
    return BlocProvider(
      create: (context) => FeedbackAdminBloc(
        requestId: requestId,
      ),
      child: status == FeedbackToSystemStatus.canGiveFeedback
          ? FeedbackAdminWidget()
          : (status == FeedbackToSystemStatus.haveGivenFeedback ||
                  status == FeedbackToSystemStatus.adminReplied)
              ? FeedbackAdminDoneWidget(
                  status: status,
                  sellingFeedback: sellingFeedback ?? Symbols.empty,
                  adminReply: replyAdmin,
                )
              : const SizedBox.shrink(),
    );
  }

  void Function() _cancelPressed(BuildContext context, String requestId) {
    return () {
      FunctionalWidgets.showCustomModalBottomSheet(
        context: context,
        child: BlocProvider(
          create: (context) => CancelRequestBloc(requestId: requestId),
          child: const CancelRequestWidget(),
        ),
        title: 'Hủy Đơn Hẹn',
        routeClosed: Routes.requestDetail,
      ).then((value) {
        if (value != null && value) {
          context.read<RequestDetailBloc>().add(RequestDetailAfterCanceled());
        }
      });
    };
  }
}

class CancelRequestWidget extends StatelessWidget {
  const CancelRequestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelRequestBloc, CancelRequestState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          showDialog(
            context: context,
            builder: (context) => const CustomProgressIndicatorDialog(),
          );
        }

        if (state.status.isSubmissionSuccess) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.SUCCES,
            title: 'Hủy yêu cầu thu gom thành công',
            desc: 'Bạn đã hủy yêu cầu thu gom thành công',
            btnOkText: 'Đóng',
            btnOkOnpress: () {
              Navigator.pop(context);
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
          );
        }
        if (state.status.isSubmissionFailure) {
          Navigator.pop(context);

          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.WARNING,
            title: 'Hủy yêu cầu thu gom thất bại',
            desc: 'Bạn không thể hủy yêu cầu thu gom',
            btnOkText: 'Đóng',
            isOkBorder: true,
            btnOkColor: AppColors.errorButtonBorder,
            textOkColor: AppColors.errorButtonText,
            btnOkOnpress: () {
              Navigator.pop(context);
              Navigator.of(context).pop();
              Navigator.of(context).pop(false);
            },
          );
        }
      },
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppConstants.horizontalScaffoldMargin.w,
            vertical: 20.h,
          ),
          margin: EdgeInsets.symmetric(
            vertical: 50.h,
          ),
          color: Colors.orange[900]!.withOpacity(0.2),
          child: Row(
            children: [
              const Icon(
                Icons.error,
                color: AppColors.orangeFFF5670A,
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 40.w,
                  ),
                  child: CustomText(
                    text:
                        'Vui lòng điền lí do hủy đơn hẹn. Lưu ý: thao tác này sẽ không thể hoàn tác',
                    color: AppColors.orangeFFF5670A,
                    fontSize: 40.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        CommonMarginContainer(
          child: TextField(
            onChanged: (value) {
              context.read<CancelRequestBloc>().add(
                    CancelReasonChanged(value),
                  );
            },
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            maxLength: 200,
            decoration: const InputDecoration(
              hintText: 'Lý do hủy',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            textInputAction: TextInputAction.done,
            autofocus: true,
          ),
        ),
        CommonMarginContainer(
          child: BlocBuilder<CancelRequestBloc, CancelRequestState>(
            builder: (context, state) {
              return ElevatedButton(
                onPressed: state.cancelReason.valid
                    ? () {
                        context.read<CancelRequestBloc>().add(
                              CancelRequestSubmmited(),
                            );
                      }
                    : null,
                child: CustomText(
                  text: 'Đồng ý',
                  fontSize: WidgetConstants.buttonCommonFrontSize.sp,
                  fontWeight: WidgetConstants.buttonCommonFrontWeight,
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(
                    double.infinity,
                    WidgetConstants.buttonCommonHeight.h,
                  ),
                  primary: AppColors.greenFF01C971,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RequestDetailTime extends StatelessWidget {
  const RequestDetailTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: BlocBuilder<RequestDetailBloc, RequestDetailState>(
        builder: (context, state) {
          return Column(
            children: [
              _getDataRow(
                  'Thời gian đặt', '${state.createdDate} ${state.createdTime}'),
              (state.status != ActivityLayoutConstants.pending &&
                      state.approvedTime.isNotEmpty &&
                      state.approvedDate.isNotEmpty)
                  ? _getDataRow(
                      'Thời gian được xác nhận',
                      '${state.approvedDate} ${state.approvedTime}',
                    )
                  : const SizedBox.shrink(),
              (state.doneActivityDate.isNotEmpty &&
                      state.doneActivityTime.isNotEmpty &&
                      state.status == ActivityLayoutConstants.completed)
                  ? _getDataRow(
                      'Thời gian thu gom',
                      '${state.doneActivityDate} ${state.doneActivityTime}',
                    )
                  : const SizedBox.shrink(),
              (state.doneActivityDate.isNotEmpty &&
                      state.doneActivityTime.isNotEmpty &&
                      (state.status ==
                              ActivityLayoutConstants.cancelByCollect ||
                          state.status ==
                              ActivityLayoutConstants.cancelBySeller ||
                          state.status ==
                              ActivityLayoutConstants.cancelBySystem))
                  ? _getDataRow(
                      'Thời gian hủy',
                      '${state.doneActivityDate} ${state.doneActivityTime}',
                    )
                  : const SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }

  Widget _getDataRow(String key, String value) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 9.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: _getCustomText(key),
          ),
          _getCustomText(value),
        ],
      ),
    );
  }

  Widget _getCustomText(String text) {
    return CustomText(
      text: text,
      fontSize: 38.sp,
      color: AppColors.black,
    );
  }
}

class RequestDetailRating extends StatelessWidget {
  const RequestDetailRating({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Column(
        children: [
          _getText('Bạn thấy dịch vụ như thế nào?'),
          _getText('(1 là thất vọng, 5 là tuyệt vời)'),
          BlocBuilder<RequestDetailBloc, RequestDetailState>(
            builder: (context, state) {
              return StarRating(
                intialRating: state.ratingFeedback,
                ignoreGestures:
                    (state.feedbackStatus == FeedbackStatus.haveGivenFeedback),
                onRatingUpdate: (rating) {
                  FunctionalWidgets.showCustomModalBottomSheet(
                    context: context,
                    child: BlocProvider(
                      create: (context) => FeedbackTransactionBloc(
                        transactionId: state.transactionId,
                        rates: rating,
                      ),
                      child: Feedback(
                        state.collectorAvatarUrl,
                        state.collectorName,
                        state.collectorPhoneNumber,
                        rating,
                      ),
                    ),
                    routeClosed: Routes.requestDetail,
                    title: 'Đánh giá dịch vụ',
                  ).then((value) => context
                      .read<RequestDetailBloc>()
                      .add(RequestDetailInitial()));
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _getText(String text) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w500,
      fontSize: 40.sp,
    );
  }
}

class Feedback extends StatelessWidget {
  Feedback(this.image, this.name, this.phone, this.initialStar, {Key? key})
      : super(key: key);
  String image;
  String name;
  String phone;
  double initialStar;
  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackTransactionBloc, FeedbackTransactionState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          FunctionalWidgets.showCustomDialog(
            context,
          );
        }

        if (state.status.isSubmissionSuccess) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.SUCCES,
            desc: 'Cảm ơn bạn đã đánh giá',
            btnOkText: 'Đóng',
            btnOkOnpress: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
          );
        }
        if (state.status.isSubmissionFailure) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.WARNING,
            desc: 'Có lỗi đến từ hệ thống',
            btnOkText: 'Đóng',
            isOkBorder: true,
            btnOkColor: AppColors.errorButtonBorder,
            textOkColor: AppColors.errorButtonText,
            btnOkOnpress: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          );
        }
      },
      child: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          child: Divider(
            thickness: 50.h,
            color: Colors.grey[100],
          ),
          margin: EdgeInsets.symmetric(
            vertical: 50.h,
          ),
        ),
        CommonMarginContainer(
          child: IntrinsicHeight(
            child: Row(
              children: [
                FutureBuilder(
                  future: image.isEmpty
                      ? Future.value(Symbols.empty)
                      : CommonUtils.getMetaDataImage(
                          image,
                        ),
                  builder: (context, snapshot) {
                    if (image.isNotEmpty && snapshot.hasData) {
                      var data = snapshot.data as List;
                      return CircleAvatar(
                        radius: 110.0.r,
                        foregroundImage: NetworkImage(data[0], headers: {
                          HttpHeaders.authorizationHeader: data[1],
                        }),
                        backgroundImage: const AssetImage(
                          ImagesPaths.maleProfile,
                        ),
                      );
                    }
                    return CircleAvatar(
                      radius: 110.0.r,
                      foregroundImage: const AssetImage(
                        ImagesPaths.maleProfile,
                      ),
                    );
                  },
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 50.w,
                  ),
                  child: CustomText(
                    text: name,
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Divider(
            thickness: 5.h,
            color: Colors.grey[100],
          ),
          margin: EdgeInsets.symmetric(
            vertical: 20.h,
          ),
        ),
        StarRating(
          onRatingUpdate: (value) {
            context
                .read<FeedbackTransactionBloc>()
                .add(FeedbackRateChanged(value));
          },
          intialRating: initialStar,
        ),
        Container(
          child: CustomText(
            text: 'Cảm ơn bạn đã đánh giá!',
            fontSize: 50.sp,
          ),
          margin: EdgeInsets.only(
            top: 20.h,
            bottom: 20.h,
          ),
        ),
        CommonMarginContainer(
          child: TextField(
            onChanged: (value) {
              context.read<FeedbackTransactionBloc>().add(
                    FeedbackReviewChanged(value),
                  );
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            maxLength: 200,
            decoration: const InputDecoration(
              hintText: 'Hãy chia sẻ trải nghiệm của bạn nhé',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.greenFF61C53D),
              ),
            ),
            textInputAction: TextInputAction.done,
            autofocus: true,
          ),
        ),
        CommonMarginContainer(
          child: ElevatedButton(
            onPressed: () {
              context
                  .read<FeedbackTransactionBloc>()
                  .add(FeedbackTransactionSubmmited());
            },
            child: CustomText(
              text: 'Gửi đánh giá',
              fontSize: WidgetConstants.buttonCommonFrontSize.sp,
              fontWeight: WidgetConstants.buttonCommonFrontWeight,
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(
                double.infinity,
                WidgetConstants.buttonCommonHeight.h,
              ),
              primary: AppColors.greenFF61C53D,
            ),
          ),
        ),
      ],
    );
  }
}

class StarRating extends StatelessWidget {
  StarRating({
    this.ignoreGestures = false,
    this.intialRating = 0,
    required this.onRatingUpdate,
    Key? key,
  }) : super(key: key);
  bool ignoreGestures;
  double intialRating;
  void Function(double) onRatingUpdate;
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: intialRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (_, __) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      ignoreGestures: ignoreGestures,
      onRatingUpdate: onRatingUpdate,
    );
  }
}

class RequestDetailBill extends StatelessWidget {
  const RequestDetailBill({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RequestDetailElementPattern(
            icon: Icons.receipt_outlined,
            title: 'Thông tin đơn hàng',
            child: _bodyBill(),
            contentLeftMargin: 0.w,
          )
        ],
      ),
    );
  }

  Widget _bodyBill() {
    return Column(
      children: [
        _getItems(),
        // _getDivider(),
        Container(
            margin: EdgeInsets.only(top: 25.h, bottom: 15.h),
            child: _getSubInfo()),
        _getDottedDivider(),
        Row(
          children: [
            Expanded(
              child: _getFinalText('Tổng cộng'),
            ),
            BlocBuilder<RequestDetailBloc, RequestDetailState>(
              builder: (context, state) {
                return _getFinalText(state.billTotal.toAppPrice());
              },
            )
          ],
        )
      ],
    );
  }

  Widget _getFinalText(String text) {
    return CustomText(
      text: text,
      fontSize: 45.sp,
      fontWeight: FontWeight.w500,
    );
  }

  Widget _getItems() {
    return BlocBuilder<RequestDetailBloc, RequestDetailState>(
      builder: (context, state) {
        return Column(
          children: state.transaction
              .map(
                (e) => _getItem(
                    e.name, e.quantity, e.unitInfo, e.total.toAppPrice()),
              )
              .toList(),
        );
      },
    );
  }

  Widget _getItem(String name, double quantity, String unit, String price) {
    return Container(
      height: 130.h,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15.r),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 50.w,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 15.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: _getItemText(
              name.isNotEmpty ? name : 'Chưa phân loại',
            ),
            width: 350.w,
          ),
          _getItemText(quantity == 0 || unit.isEmpty
              ? Symbols.minus
              : '${quantity.toStringAndRemoveFractionalIfCan()} $unit'),
          _getItemText(price),
        ],
      ),
    );
  }

  _getItemText(String text) {
    return CustomText(
      text: text,
      fontSize: 40.sp,
      color: Colors.grey[800],
    );
  }

  _getDivider() {
    return Divider(
      thickness: 2.5.h,
    );
  }

  _getDottedDivider() {
    return Container(
      padding: EdgeInsets.only(top: 10.h, bottom: 30.h),
      child: DottedLine(
        direction: Axis.horizontal,
        dashGapLength: 3.0,
        dashColor: AppColors.greyFFB5B5B5,
      ),
    );
  }

  Widget _getSubInfo() {
    return BlocBuilder<RequestDetailBloc, RequestDetailState>(
      builder: (context, state) {
        return Column(
          children: [
            _getSubInfoItem(
              'Tạm tính',
              state.itemTotal.toAppPrice(),
            ),
            _getSubInfoItem(
              'Phí dịch vụ',
              '-${state.serviceFee.toAppPrice()}',
            ),
            _getSubInfoItem(
              'Điểm thưởng',
              '${state.point} điểm',
            ),
          ],
        );
      },
    );
  }

  Widget _getSubInfoItem(String name, String value) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 12.h,
      ),
      child: Row(
        children: [
          Expanded(
            child: _getSubInfoItemText(name),
          ),
          _getSubInfoItemText(value),
        ],
      ),
    );
  }

  Widget _getSubInfoItemText(String text) {
    return CustomText(
      text: text,
      color: AppColors.black,
      fontSize: 38.sp,
    );
  }
}

class RequestDetailCollectorInfo extends StatelessWidget {
  const RequestDetailCollectorInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestDetailBloc, RequestDetailState>(
      builder: (context, state) {
        return CommonMarginContainer(
          child: IntrinsicHeight(
            child: Row(
              children: [
                FutureBuilder(
                  future: state.collectorAvatarUrl.isEmpty
                      ? Future.value(Symbols.empty)
                      : CommonUtils.getMetaDataImage(
                          state.collectorAvatarUrl,
                        ),
                  builder: (context, snapshot) {
                    if (state.collectorAvatarUrl.isNotEmpty &&
                        snapshot.hasData) {
                      var data = snapshot.data as List;
                      return CircleAvatar(
                        radius: 90.0.r,
                        foregroundImage: NetworkImage(data[0], headers: {
                          HttpHeaders.authorizationHeader: data[1],
                        }),
                        backgroundImage: const AssetImage(
                          ImagesPaths.maleProfile,
                        ),
                      );
                    }
                    return CircleAvatar(
                      radius: 90.0.r,
                      foregroundImage: const AssetImage(
                        ImagesPaths.maleProfile,
                      ),
                    );
                  },
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 50.w,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _getLineInfo(
                              Icons.person_outline, state.collectorName),
                          SizedBox(
                            width: 20.w,
                          ),
                          _getLineInfoCustom(
                            Icons.star,
                            state.collectorRating.toStringOneFixed(),
                            AppColors.orangeFFF5A91F,
                          ),
                        ],
                      ),
                      state.status == ActivityLayoutConstants.approved
                          ? GestureDetector(
                              onTap: () async {
                                var url = "tel:${state.collectorPhoneNumber}";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  AppLog.error('Could not launch $url');
                                }
                              },
                              child: Row(
                                children: [
                                  _getLineInfo(Icons.phone_outlined,
                                      state.collectorPhoneNumber),
                                  Container(
                                      margin: EdgeInsets.only(left: 20.w),
                                      child: Text(
                                        'Gọi',
                                        style: TextStyle(
                                          // decoration: TextDecoration.underline,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 40.sp,
                                        ),
                                      )),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _getLineInfo(IconData icon, String data,
      [Color? colorIcon = AppColors.greenFF61C53D]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: colorIcon,
          size: 55.sp,
        ),
        Container(
          margin: EdgeInsets.only(
            left: 15.w,
          ),
          child: CustomText(
            text: data,
            fontSize: 45.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _getLineInfoCustom(IconData icon, String data,
      [Color? colorIcon = AppColors.greenFF61C53D]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: colorIcon,
          size: 40.sp,
        ),
        Container(
          margin: EdgeInsets.only(
            left: 5.w,
          ),
          child: CustomText(
            text: data,
            fontSize: 35.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class RequestDetailBody extends StatelessWidget {
  const RequestDetailBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Thông tin đặt hẹn',
            fontSize: 40.sp,
            fontWeight: FontWeight.w500,
          ),
          BlocBuilder<RequestDetailBloc, RequestDetailState>(
            builder: (c, s) {
              return Container(
                child: Column(
                  children: [
                    RequestDetailElementPattern(
                      icon: Icons.place,
                      title: 'Địa chỉ thu gom',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            fontSize: 47.sp,
                            text: s.addressName,
                            fontWeight: FontWeight.w500,
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 12.h,
                            ),
                            child: CustomText(
                              text: s.address,
                              fontSize: 39.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    s.status == ActivityLayoutConstants.pending ||
                            s.status == ActivityLayoutConstants.approved
                        ? RequestDetailElementPattern(
                            icon: AppIcons.event,
                            title: 'Thời gian hẹn thu gom',
                            child: CustomText(
                              text:
                                  '${s.collectingRequestDate}, ${s.fromTime} - ${s.toTime}',
                              fontSize: 47.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox.shrink(),
                    s.status == ActivityLayoutConstants.pending ||
                            s.status == ActivityLayoutConstants.approved
                        ? RequestDetailElementPattern(
                            icon: Icons.kitchen,
                            title: 'Có đồ cồng kềnh',
                            child: CustomText(
                              text: s.isBulky ? 'Có' : 'Không',
                              fontSize: 47.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : const SizedBox.shrink(),
                    (s.status == ActivityLayoutConstants.pending ||
                                s.status == ActivityLayoutConstants.approved) &&
                            s.scrapCategoryImageUrl != null &&
                            s.scrapCategoryImageUrl!.isNotEmpty
                        ? RequestDetailElementPattern(
                            icon: Icons.image_outlined,
                            title: 'Ảnh ve chai',
                            child: _image(context, s.scrapCategoryImageUrl!),
                          )
                        : const SizedBox.shrink(),
                    s.status == ActivityLayoutConstants.pending ||
                            s.status == ActivityLayoutConstants.approved
                        ? RequestDetailElementPattern(
                            icon: Icons.notes,
                            title: 'Ghi chú',
                            child: CustomText(
                              text: s.note,
                              fontSize: 40.sp,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _image(BuildContext context, String url) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: 40.h,
        ),
        constraints: BoxConstraints(maxHeight: 600.h, minHeight: 400.h),
        child:
            // ''.isEmpty
            //     ? Stack(
            //         children:
            //         <Widget>[
            ClipRRect(
          borderRadius: BorderRadius.circular(20.0.r),
          child: FutureBuilder<List>(
            future: getMetaDataImage(url),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var image = FadeInImage(
                  image: NetworkImage(snapshot.data![0], headers: {
                    HttpHeaders.authorizationHeader: snapshot.data![1],
                  }),
                  placeholder: const AssetImage(
                    ImagesPaths.placeholderImage,
                  ),
                );

                return GestureDetector(
                  child: image,
                  onTap: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => ViewImageLayout(
                          imageProvider: image.image,
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Image.asset(
                  ImagesPaths.placeholderImage,
                );
              }
            },
          ),
        ),
        // Positioned.fill(
        //   child: Container(
        //     height: double.minPositive,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(20.0.r),
        //       color: Colors.black.withOpacity(0.4),
        //     ),
        //     child: IconButton(
        //       color: Colors.white,
        //       icon: const Icon(Icons.add_a_photo_outlined),
        //       onPressed: () {
        //         // showDialog(
        //         //   context: context,
        //         //   builder: (context) => const ExistedPhotoDialog(),
        //         // );
        //       },
        //     ),
        //   ),
        // )
        // ],F
        // )
        // : CircleAvatar(
        //     backgroundColor: Colors.deepOrange,
        //     radius: 100.0.r,
        //     child: IconButton(
        //       onPressed: () {
        //         // showDialog(
        //         //   context: context,
        //         //   builder: (context) => const PhotoDialog(),
        //         // );
        //       },
        //       icon: Icon(
        //         Icons.add_a_photo_outlined,
        //         size: 80.0.r,
        //         color: AppColors.white,
        //       ),
        //     ),
        //   ),
      ),
    );
  }

  Future<List> getMetaDataImage(String imagePath) async {
    var bearerToken = NetworkUtils.getBearerToken();
    var url = NetworkUtils.getUrlWithQueryString(
      APIServiceURI.imageGet,
      {'imageUrl': imagePath},
    );
    return [
      url,
      await bearerToken,
    ];
  }
}

// ignore: must_be_immutable
class RequestDetailElementPattern extends StatelessWidget {
  RequestDetailElementPattern({
    Key? key,
    required this.icon,
    required this.title,
    required this.child,
    double? contentLeftMargin,
  }) : super(key: key) {
    this.contentLeftMargin = contentLeftMargin ?? 80.w;
  }

  final IconData icon;
  final String title;
  final Widget child;
  late double contentLeftMargin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 30.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RadiantGradientMask(
                child: Icon(
                  icon,
                  color: AppColors.greenFF61C53D,
                  size: 60.sp,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    left: 20.w,
                  ),
                  child: CustomText(
                    text: title,
                    fontSize: 40.sp,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20.h,
              left: contentLeftMargin,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}

class RequestDetailHeader extends StatelessWidget {
  const RequestDetailHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommonMarginContainer(
      child: Container(
        constraints: BoxConstraints(
          minHeight: 200.h,
        ),
        child: BlocBuilder<RequestDetailBloc, RequestDetailState>(
          builder: (c, s) {
            return Column(
              children: <Widget>[
                _requestId(
                  context,
                  s.id,
                  s.collectingRequestCode,
                ),
                _getHeaderStatus(context, s.status),
                (s.cancelReason.isNotEmpty &&
                        (s.status == ActivityLayoutConstants.cancelByCollect ||
                            s.status ==
                                ActivityLayoutConstants.cancelBySeller) &&
                        !s.isCancelable)
                    ? _cancelReason(
                        context,
                        s.cancelReason,
                      )
                    : const SizedBox.shrink()
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _cancelReason(BuildContext context, String cancelReason) {
    return Container(
      padding: EdgeInsets.only(
        top: 50.h,
        left: 80.w,
      ),
      width: double.infinity,
      child: RichText(
        text: TextSpan(
            text: 'Lý do: ',
            style: TextStyle(
              color: Colors.black,
              fontSize: 45.sp,
              fontWeight: FontWeight.w500,
            ),
            children: [
              TextSpan(
                text: cancelReason,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ]),
      ),
      // child: CustomText(
      //   text: 'Lý do: $cancelReason',
      //   textAlign: TextAlign.start,
      //   fontSize: 40.sp,
      // ),
    );
  }

  Widget _getHeaderStatus(BuildContext context, int status) {
    switch (status) {
      case ActivityLayoutConstants.pending:
      case ActivityLayoutConstants.approved:
      case ActivityLayoutConstants.completed:
        return _getStepper(context, status);
      case ActivityLayoutConstants.cancelByCollect:
        return _getStatusTextHeader('Bị hủy');
      case ActivityLayoutConstants.cancelBySeller:
        return _getStatusTextHeader('Đã hủy');
      case ActivityLayoutConstants.cancelBySystem:
        return _getStatusTextHeader('Bị hủy bởi hệ thống');
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _getStatusTextHeader(String text) {
    return Container(
      margin: EdgeInsets.only(
        left: 85.w,
      ),
      width: double.infinity,
      child: CustomText(
        text: text,
        textAlign: TextAlign.start,
        fontSize: 40.sp,
        color: AppColors.orangeFFF5670A,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _requestId(BuildContext context, String id, String code) {
    return Row(
      children: <Widget>[
        RadiantGradientMask(
          child: const Icon(
            Icons.description_outlined,
            color: AppColors.greenFF61C53D,
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            child: CustomText(
              text: 'Mã Đơn Hẹn: $code',
              fontWeight: FontWeight.w500,
              fontSize: 35.sp,
            ),
          ),
        ),
        // IconButton(
        //   onPressed: () {
        //     FunctionalWidgets.showCustomModalBottomSheet<String>(
        //       context: context,
        //       child: _getQrCode(id, code),
        //       routeClosed: Routes.requestDetail,
        //     );
        //   },
        //   icon: Icon(
        //     Icons.qr_code_2_outlined,
        //     size: 80.sp,
        //   ),
        // ),
      ],
    );
  }

  Widget _getQrCode(String id, String code) {
    return Container(
      margin: EdgeInsets.only(
        top: 400.h,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: 'Đơn hẹn\n$code',
              textAlign: TextAlign.center,
              fontSize: 50.sp,
              fontWeight: FontWeight.w500,
            ),
            QrImage(
              data: id,
              version: QrVersions.auto,
              size: 600.r,
            ),
          ],
        ),
      ),
    );
  }

  Widget _getStepper(BuildContext context, int status) {
    return Container(
      height: 220.h,
      child: Theme(
        data: Theme.of(context).copyWith(
          shadowColor: Colors.transparent,
        ),
        child: Stepper(
          type: StepperType.horizontal,
          controlsBuilder: (context, {onStepCancel, onStepContinue}) {
            return Row(
              children: <Widget>[
                Container(
                  child: null,
                ),
                Container(
                  child: null,
                ),
                Container(
                  child: null,
                ),
              ], // <Widget>[]
            );
          },
          currentStep: 0,
          steps: <Step>[
            Step(
              state: StepState.complete,
              isActive: status == ActivityLayoutConstants.pending ||
                  status == ActivityLayoutConstants.approved ||
                  status == ActivityLayoutConstants.completed,
              title: CustomText(
                text: 'Đặt hẹn',
                fontSize: 28.sp,
              ),
              content: Container(),
            ),
            Step(
              state: StepState.complete,
              isActive: status == ActivityLayoutConstants.approved ||
                  status == ActivityLayoutConstants.completed,
              title: CustomText(
                text: 'Đã nhận',
                fontSize: 28.sp,
              ),
              content: Container(),
            ),
            Step(
              state: StepState.complete,
              isActive: status == ActivityLayoutConstants.completed,
              title: CustomText(
                text: 'Hoàn thành',
                fontSize: 28.sp,
              ),
              content: Container(),
            )
          ],
        ),
      ),
    );
  }
}

class RequestDetailDivider extends StatelessWidget {
  const RequestDetailDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      thickness: 20.h,
      height: 100.h,
      color: AppColors.greyFFEEEEEE,
    );
  }
}

class FeedbackAdminWidget extends StatelessWidget {
  FeedbackAdminWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FeedbackAdminBloc, FeedbackAdminState>(
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          showDialog(
            context: context,
            builder: (context) => const CustomProgressIndicatorDialog(),
          );
        }

        if (state.status.isSubmissionSuccess) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.SUCCES,
            desc: 'Bạn đã gửi phản hồi đến hệ thống',
            btnOkText: 'Đóng',
            btnOkOnpress: () {
              Navigator.pop(context);
              Navigator.of(context).pop();
              Navigator.of(context).pop(true);
            },
          );
        }
        if (state.status.isSubmissionFailure) {
          FunctionalWidgets.showAwesomeDialog(
            context,
            dialogType: DialogType.WARNING,
            desc: 'Có lỗi đến từ hệ thống',
            btnOkText: 'Đóng',
            isOkBorder: true,
            btnOkColor: AppColors.errorButtonBorder,
            textOkColor: AppColors.errorButtonText,
            btnOkOnpress: () {
              Navigator.pop(context);
              Navigator.of(context).pop();
              Navigator.of(context).pop(false);
            },
          );
        }
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppConstants.horizontalScaffoldMargin.w,
              vertical: 20.h,
            ),
            margin: EdgeInsets.symmetric(
              vertical: 50.h,
            ),
            color: Colors.orange[900]!.withOpacity(0.2),
            child: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: AppColors.orangeFFF5670A,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 40.w,
                    ),
                    child: CustomText(
                      text:
                          'Vui lòng điền thông tin bạn muốn phản hồi về VeChaiXANH',
                      color: AppColors.orangeFFF5670A,
                      fontSize: 40.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CommonMarginContainer(
            child: TextField(
              onChanged: (value) {
                context.read<FeedbackAdminBloc>().add(
                      FeedbackAdminChanged(value),
                    );
              },
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              maxLength: 200,
              decoration: const InputDecoration(
                hintText: 'Thông tin phản hồi',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
              textInputAction: TextInputAction.done,
              autofocus: true,
            ),
          ),
          CommonMarginContainer(
            child: BlocBuilder<FeedbackAdminBloc, FeedbackAdminState>(
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: state.status.isValid
                      ? () {
                          context
                              .read<FeedbackAdminBloc>()
                              .add(FeedbackAdminSubmmited());
                        }
                      : null,
                  child: CustomText(
                    text: 'Gửi',
                    fontSize: WidgetConstants.buttonCommonFrontSize.sp,
                    fontWeight: WidgetConstants.buttonCommonFrontWeight,
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(
                      double.infinity,
                      WidgetConstants.buttonCommonHeight.h,
                    ),
                    primary: AppColors.greenFF01C971,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackAdminDoneWidget extends StatelessWidget {
  FeedbackAdminDoneWidget({
    Key? key,
    required this.status,
    required this.sellingFeedback,
    this.adminReply,
  }) : super(key: key);

  final int status;
  final String sellingFeedback;
  final String? adminReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: CommonMarginContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _content(
              'Phản hồi của bạn:',
              sellingFeedback,
            ),
            adminReply != null && adminReply!.isNotEmpty
                ? _content(
                    'Hồi đáp từ quản trị viên:',
                    adminReply!,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _content(String title, String content) {
    return Container(
      margin: EdgeInsets.only(
        top: 80.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: title,
            fontSize: 50.sp,
            fontWeight: FontWeight.w500,
          ),
          Container(
            padding: EdgeInsets.only(left: 50.w, top: 30.h),
            child: CustomText(
              text: content,
              fontSize: 45.sp,
            ),
          ),
        ],
      ),
    );
  }
}
