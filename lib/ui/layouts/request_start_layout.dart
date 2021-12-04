import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/blocs/request_bloc.dart';
import 'package:seller_app/blocs/request_time_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/log/logger.dart';
import 'package:seller_app/ui/layouts/request_location_picker_layout.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:seller_app/ui/widgets/radiant_gradient_mask.dart';
import 'package:seller_app/ui/widgets/sumitted_button.dart';
import 'package:seller_app/utils/common_utils.dart';
import 'package:seller_app/utils/extension_methods.dart';
import 'package:formz/formz.dart';

class RequestStartLayout extends StatelessWidget {
  const RequestStartLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<RequestBloc>(context)
        ..add(
          RequestStateInitial(),
        )
        ..add(
          RequestAddressInitial(),
        )
        ..add(
          PersonalLocationGet(),
        ),
      child: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state.newPersonalLocationStatus ==
              NewPersonalLocationStatus.bNew) {
            context.read<RequestBloc>().add(RefreshCheckPersonalLocation());
            FunctionalWidgets.showAwesomeDialog(
              context,
              desc: 'Bạn có muốn lưu địa chỉ này không?',
              dialogType: DialogType.QUESTION,
              btnCancelText: 'Không',
              btnOkText: 'Có',
              btnOkOnpress: () {
                Navigator.of(context).pop();
                showDialogForNewPersonalLocationInput(
                    context,
                    state.address.value.name! +
                        '\n' +
                        state.address.value.address!);
              },
              dismissBack: false,
            );
          } else if (state.newPersonalLocationStatus ==
              NewPersonalLocationStatus.success) {
            context.read<RequestBloc>().add(RefreshCheckPersonalLocation());
            FunctionalWidgets.showSnackBar(context, 'Đã thêm địa chỉ mới');
          } else if (state.newPersonalLocationStatus ==
              NewPersonalLocationStatus.error) {
            context.read<RequestBloc>().add(RefreshCheckPersonalLocation());
            FunctionalWidgets.showSnackBar(context, 'Có lỗi đến từ hệ thống');
          }
        },
        child: BlocProvider.value(
          value: BlocProvider.of<RequestTimeBloc>(context)
            ..add(
              RequestTimeInitial(),
            ),
          child: BlocListener<RequestTimeBloc, RequestTimeState>(
            listener: (context, state) {
              if (state.blocStatus.isSubmissionInProgress) {
                FunctionalWidgets.showCustomDialog(context);
              }
              if (state.blocStatus.isSubmissionSuccess) {
                Navigator.of(context).popUntil(
                  ModalRoute.withName(Routes.requestStart),
                );
              }
              if (state.blocStatus.isSubmissionFailure) {
                Navigator.of(context).popUntil(
                  ModalRoute.withName(Routes.requestStart),
                );
              }
            },
            child: Scaffold(
              appBar: FunctionalWidgets.buildAppBar(
                context: context,
                elevation: 0,
                color: AppColors.black,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              body: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: AppConstants.horizontalScaffoldMargin.w,
                ),
                child: BlocBuilder<RequestBloc, RequestState>(
                  builder: (context, state) {
                    return state.personalLocationStatus.isSubmissionSuccess
                        ? const _Body()
                        : Center(
                            child: FunctionalWidgets.getLoadingAnimation(),
                          );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<T?> showDialogForNewPersonalLocationInput<T>(
      BuildContext context, String placeAdress) {
    String placeName = Symbols.empty;
    return showDialog<T>(
      context: context,
      barrierDismissible:
          false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Địa điểm'),
                onChanged: (value) {
                  placeName = value;
                },
              ),
              TextFormField(
                initialValue: placeAdress,
                enabled: false,
                maxLines: null,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const CustomText(text: 'Đóng'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const CustomText(text: 'Lưu'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value is bool && value) {
        context.read<RequestBloc>().add(
              AddPersonalLocation(placeName),
            );
      }
    });
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0XFFF8F8F8),
      child: Column(
        children: <Widget>[
          const _Title(),
          Expanded(
            child: ListView(
              children: [
                const _Form(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({Key? key}) : super(key: key);

  Widget getSizeboxcolumn() {
    return SizedBox(
      height: 45.h,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              onTap: _onPlaceInputTapped(
                context,
                state.address.value.name ?? Symbols.empty,
              ),
              child: _InputContainer(
                child: state.address.valid
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          CustomText(
                            fontSize: 45.sp,
                            fontWeight: FontWeight.w500,
                            text: state.address.value.name!,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          CustomText(
                            fontSize: 40.sp,
                            text: state.address.value.address!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      )
                    : CustomText(
                        text: RequestStartLayoutConstants.placeHintText,
                        color: AppColors.greyFF9098B1,
                        fontSize: RequestStartLayoutConstants.inputFontSize.sp,
                      ),
                iconData: AppIcons.place,
              ),
            ),
            GestureDetector(
              onTap: _onTimeInputTapped(context),
              child: _InputContainer(
                child: BlocBuilder<RequestBloc, RequestState>(
                  builder: (context, state) {
                    return state.date != null &&
                            state.fromTime != null &&
                            state.toTime != null
                        ? CustomText(
                            text: CommonUtils.isOnlyNow(
                                    state.date!, state.fromTime!, state.toTime!)
                                ? 'Đến ngay'
                                : CommonUtils.combineDateToTime(
                                    state.date!,
                                    state.fromTime!.format(context),
                                    state.toTime!.format(context)),
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                            fontSize:
                                RequestStartLayoutConstants.inputFontSize.sp,
                          )
                        : CustomText(
                            text: RequestStartLayoutConstants.timeHintText,
                            color: AppColors.greyFF9098B1,
                            fontSize:
                                RequestStartLayoutConstants.inputFontSize.sp,
                          );
                  },
                ),
                iconData: AppIcons.event,
              ),
            ),
            const _InputContainer(
              child: _NoteField(),
              iconData: AppIcons.feedOutlined,
            ),
            getSizeboxcolumn(),
            BlocBuilder<RequestBloc, RequestState>(
              builder: (context, state) {
                return SubmittedButton(
                  title: RequestStartLayoutConstants.firstButtonTitle,
                  onPressed: (context) => () {
                    Navigator.of(context).pushNamed(Routes.requestBulky);
                  },
                  activated: state.status.isValid,
                );
              },
            )
          ],
        );
      },
    );
  }

  Function() _onTimeInputTapped(BuildContext context) {
    return () {
      showTimeInputDialog(context);
    };
  }

  Function()? _onPlaceInputTapped(BuildContext context, String value) {
    return () {
      Navigator.of(context)
          .pushNamed(
        Routes.requestLocationPicker,
        arguments: RequestLocationPickerArguments(value),
      )
          .then((value) {
        if (value != null && value is bool && value) {
          context.read<RequestBloc>().add(CheckPersonalLocation());
        }
      });
    };
  }

  void showTimeInputDialog(BuildContext context) {
    DateTime? date;
    TimeOfDay? fromTime, toTime;

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<RequestTimeBloc, RequestTimeState>(
          builder: (context, state) {
            date = state.date;
            fromTime = state.fromTime;
            toTime = state.toTime;
            return _TimeInputDialog(
              onPressedActivated: state.status == RequestTimeStatus.valid,
            );
          },
        );
      },
    ).then((value) {
      if (value == null) return;
      try {
        if (value == RequestStartLayoutConstants.requestBook) {
          context.read<RequestBloc>().add(
                RequestTimePicked(
                  date: date ?? DateTime.now(),
                  toTime: toTime ?? TimeOfDay.now(),
                  fromTime: fromTime ?? TimeOfDay.now(),
                ),
              );
        } else if (value == RequestStartLayoutConstants.requestNow) {
          var time = const TimeOfDay(hour: 00, minute: 00);
          context.read<RequestBloc>().add(
                RequestTimePicked(
                  date: DateTime.now().onlyDate(),
                  toTime: time,
                  fromTime: time,
                ),
              );
        }
      } catch (_) {
        AppLog.error('Value is not number');
      }
    });
  }
}

class _AlertDialog extends StatelessWidget {
  const _AlertDialog({
    Key? key,
    required this.content,
    this.onPressedActived = true,
  }) : super(key: key);
  final Widget content;
  final bool onPressedActived;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: content,
      actions: <Widget>[
        _getButton('HỦY', false, context),
        _getButton(
          'XÁC NHẬN',
          true,
          context,
          onPressedActivated: onPressedActived,
        ),
      ],
    );
  }

  Widget _getText(String text) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w500,
      fontSize: 40.sp,
    );
  }

  Widget _getButton(
    String name,
    bool value,
    BuildContext context, {
    bool onPressedActivated = true,
  }) {
    return TextButton(
      onPressed:
          onPressedActivated ? () => Navigator.of(context).pop(value) : null,
      child: _getText(name),
    );
  }
}

class _TimeInputDialog extends StatelessWidget {
  const _TimeInputDialog({
    this.onPressedActivated = true,
    Key? key,
  }) : super(key: key);

  final bool onPressedActivated;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        width: 800.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _container(
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: _onCloseIconPressed(context),
                    icon: _getIcon(
                      Icons.close,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: 'Đặt hẹn lúc',
                          color: Colors.grey.shade600,
                        ),
                        BlocBuilder<RequestTimeBloc, RequestTimeState>(
                          builder: (context, state) {
                            return _getText(
                              CommonUtils.combineDateToTime(
                                  state.date,
                                  state.fromTime.format(context),
                                  state.toTime.format(context)),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _getDivider(),
            BlocBuilder<RequestTimeBloc, RequestTimeState>(
              builder: (context, state) {
                var isOnlyNow = CommonUtils.isOnlyNow(
                    state.date, state.fromTime, state.toTime);
                return InkWell(
                  onTap: isOnlyNow
                      ? null
                      : _onDateTap(context, state.date, state.chosableDates),
                  child: _container(
                    Row(
                      children: <Widget>[
                        _getIcon(
                          Icons.date_range_outlined,
                        ),
                        Expanded(
                          child: BlocBuilder<RequestTimeBloc, RequestTimeState>(
                            builder: (context, state) {
                              return _getText(
                                isOnlyNow
                                    ? Symbols.empty
                                    : CommonUtils.convertDateTimeToVietnamese(
                                        state.date,
                                      ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            _getDivider(),
            _container(
              Row(
                children: <Widget>[
                  _getIcon(
                    Icons.schedule_outlined,
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        BlocBuilder<RequestTimeBloc, RequestTimeState>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: _onTimeTap(
                                  context, state.fromTime, _onFromTimeEvent),
                              child: _getTimeText(
                                state.fromTime.format(context),
                              ),
                            );
                          },
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 45.w,
                          ),
                          child: _getText('-'),
                        ),
                        BlocBuilder<RequestTimeBloc, RequestTimeState>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: _onTimeTap(
                                  context, state.toTime, _onToTimeEvent),
                              child: _getTimeText(
                                state.toTime.format(context),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            BlocBuilder<RequestTimeBloc, RequestTimeState>(
              builder: (context, state) {
                return _getErrorTimeInput(context, state.status, state);
              },
            ),
            _getDivider(),
            getActions(context),
          ],
        ),
      ),
    );
  }

  bool isNowAvailable(List<DateTime> listDAte) {
    if (listDAte.isNotEmpty && listDAte[0].isSameDate(DateTime.now())) {
      return true;
    }
    return false;
  }

  Widget getActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        BlocBuilder<RequestTimeBloc, RequestTimeState>(
          builder: (context, state) {
            return OutlinedButton(
              onPressed: isNowAvailable(state.chosableDates)
                  ? () {
                      Navigator.of(context)
                          .pop(RequestStartLayoutConstants.requestNow);
                    }
                  : null,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 60.w,
                  vertical: 30.h,
                ),
              ),
              child: CustomText(
                text: "Đến ngay",
                fontSize: 50.sp,
              ),
            );
          },
        ),
        ElevatedButton(
          onPressed: onPressedActivated
              ? () => Navigator.of(context)
                  .pop(RequestStartLayoutConstants.requestBook)
              : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: 60.w,
              vertical: 30.h,
            ),
          ),
          child: CustomText(
            text: "Xác nhận",
            fontSize: 50.sp,
          ),
        )
      ],
    );
  }

  Widget _getErrorTimeInput(
      BuildContext context, RequestTimeStatus status, RequestTimeState s) {
    String text = '';

    switch (status) {
      case RequestTimeStatus.lessThanNow:
        text =
            'Thời gian bắt đầu tối thiểu phải lớn hơn thời gian hiện tại 15 phút';
        break;
      case RequestTimeStatus.notenough15fromtime:
        text =
            'Thời gian bắt đầu tối thiểu phải lớn hơn thời gian hiện tại 15 phút';
        break;
      case RequestTimeStatus.rangeTimeBetweenTwonotenough:
        text = 'Khoảng thời gian phải tối thiểu 15 phút';
        break;
      case RequestTimeStatus.notinrangetime:
        text =
            'Thời gian hẹn phải nằm trong khoảng ${s.operatingFromTime!.format(context)} - ${s.operatingTotime!.format(context)}';
        break;
      default:
    }

    return text.isEmpty
        ? const SizedBox.shrink()
        : Container(
            margin: EdgeInsets.only(
              top: 40.h,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.error,
                  color: AppColors.red,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: 40.w,
                    ),
                    child: CustomText(
                      text: text,
                      color: AppColors.red,
                      fontSize: 40.sp,
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Function() _onCloseIconPressed(BuildContext context) {
    return () {
      Navigator.of(context).popUntil(
        ModalRoute.withName(Routes.requestStart),
      );
    };
  }

  bool Function(DateTime) _validateDate(List<DateTime> chosenDates) {
    return (date) {
      if (date.isSameDate(DateTime.now())) {
        return false;
      }
      for (var eachdate in chosenDates) {
        if (date.isSameDate(DateTime.now()) &&
            eachdate.isSameDate(DateTime.now())) {
          return false;
        }
        if (eachdate.isSameDate(date)) {
          return true;
        }
      }
      return false;
    };
  }

  Function() _onDateTap(
      BuildContext context, DateTime init, List<DateTime> chosableDates) {
    return () async {
      var now = DateTime.now();
      var result = await showDatePicker(
        context: context,
        initialDate: init,
        firstDate: now,
        selectableDayPredicate: _validateDate(chosableDates),
        lastDate: now.add(
          const Duration(days: 6),
        ),
        locale: const Locale(
          Symbols.vietnamLanguageCode,
          Symbols.vietnamISOCode,
        ),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        confirmText: 'XÁC NHẬN',
      );
      if (result != null) {
        context.read<RequestTimeBloc>().add(
              RequestTimeDatePicked(result),
            );
      }
    };
  }

  void _onFromTimeEvent(BuildContext context, DateTime dateTime) {
    context.read<RequestTimeBloc>().add(RequestTimeTimeFromPicked(dateTime));
  }

  void _onToTimeEvent(BuildContext context, DateTime dateTime) {
    context.read<RequestTimeBloc>().add(RequestTimeTimeToPicked(dateTime));
  }

  Function() _onTimeTap(BuildContext context, TimeOfDay init,
      Function(BuildContext, DateTime) event) {
    return () {
      DateTime time = DateTime(0, 0, 0, init.hour, init.minute);
      showDialog(
        context: context,
        builder: (context) {
          return _AlertDialog(
            content: Container(
              height: 600.h,
              child: CupertinoDatePicker(
                onDateTimeChanged: (value) {
                  time = value;
                },
                use24hFormat: false,
                mode: CupertinoDatePickerMode.time,
                minuteInterval: RequestMapPickerLayoutConstants.minuteInterval,
                initialDateTime: DateTime(0, 0, 0, init.hour, init.minute),
              ),
            ),
          );
        },
      ).then((value) {
        if (value == null) return;
        if (value) {
          event(context, time);
        } else {
          return;
        }
      });
    };
  }

  // Widget _body(BuildContext context) {
  //   return Align(
  //     child: Container(
  //       height: double.infinity,
  //       child: Dialog(
  //         child: Container(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: AppConstants.horizontalScaffoldMargin.w,
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Container(
  //                 margin: EdgeInsets.only(
  //                   top: 80.h,
  //                   bottom: 20.h,
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.end,
  //                   children: <Widget>[
  //                     TextButton(
  //                       onPressed: () {},
  //                       child: _getText('Hủy'),
  //                     ),
  //                     SizedBox(
  //                       width: 40.w,
  //                     ),
  //                     TextButton(
  //                       onPressed: () {},
  //                       child: _getText('Xác nhận'),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _container(Widget widget) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 10.h,
      ),
      child: widget,
    );
  }

  Widget _getTimeText(String time) {
    return Container(
      height: 80.h,
      width: 170.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(1, 2),
          ),
        ],
        color: Colors.white,
      ),
      child: Center(
        child: _getText(
          time,
        ),
      ),
    );
  }

  Widget _getText(String text) {
    return CustomText(
      text: text,
      fontWeight: FontWeight.w500,
      fontSize: 43.sp,
    );
  }

  Widget _getIcon(IconData iconData) {
    return Container(
      margin: EdgeInsets.only(
        right: 40.w,
      ),
      child: Icon(
        iconData,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _getDivider() {
    return const Divider(
      thickness: 1,
    );
  }
}

// class _TitleInput extends StatelessWidget {
//   const _TitleInput({
//     Key? key,
//     required this.child,
//     required this.iconData,
//   }) : super(key: key);

//   final Widget child;
//   final IconData iconData;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Container(
//           margin: EdgeInsets.only(
//             right: 30.w,
//           ),
//           child: Icon(
//             iconData,
//             color: AppColors.greenFF61C53D,
//           ),
//         ),
//         Expanded(
//           child: child,
//         ),
//       ],
//     );
//   }
// }

class _InputContainer extends StatelessWidget {
  const _InputContainer({
    Key? key,
    required this.child,
    required this.iconData,
  }) : super(key: key);
  final Widget child;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 25.sp,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 30.0.h,
        horizontal: 30.0.w,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: <BoxShadow>[
          const BoxShadow(
            color: AppColors.greyFF9098B1,
            offset: Offset(3.5, 3.5),
            blurRadius: 6,
            spreadRadius: -5.5,
          ),
        ],
        border: Border.all(color: AppColors.greyFFB5B5B5, width: 1.w),
        borderRadius: BorderRadius.circular(
          15.0.r,
        ),
      ),
      constraints: BoxConstraints(minHeight: 180.h),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              right: 30.w,
            ),
            child: RadiantGradientMask(
              child: Icon(
                iconData,
                color: AppColors.greenFF01C971,
                size: 55.sp,
              ),
            ),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
    );
  }
}

class _NoteField extends StatelessWidget {
  const _NoteField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBloc, RequestState>(
      builder: (context, state) {
        return TextField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          maxLength: 200,
          decoration: const InputDecoration(
            hintStyle: TextStyle(
              color: AppColors.greyFF9098B1,
            ),
            isDense: true,
            contentPadding: EdgeInsets.all(0),
            border: InputBorder.none,
            hintText: RequestStartLayoutConstants.noteHintText,
          ),
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            context.read<RequestBloc>().add(RequestNoteChanged(value));
          },
        );
      },
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        bottom: 40.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CustomText(
            text: RequestStartLayoutConstants.title,
            fontSize: 65.sp,
            fontWeight: FontWeight.w500,
          ),
          const CustomText(
            text: RequestStartLayoutConstants.subTitle,
          ),
        ],
      ),
    );
  }
}
