import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:seller_app/blocs/booking_bloc.dart';
import 'package:seller_app/blocs/booking_time_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:seller_app/ui/widgets/map_widget.dart';
import 'package:seller_app/ui/widgets/sumitted_button.dart';
import 'package:seller_app/utils/common_utils.dart';

class BookingStartLayout extends StatelessWidget {
  const BookingStartLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              onTap: _onPlaceInputTapped(context),
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
                        text: BookingStartLayoutConstants.placeHintText,
                        color: AppColors.greyFF9098B1,
                        fontSize: BookingStartLayoutConstants.inputFontSize.sp,
                      ),
                iconData: AppIcons.place,
              ),
            ),
            GestureDetector(
              onTap: _onTimeInputTapped(context),
              child: _InputContainer(
                child: BlocBuilder<BookingBloc, BookingState>(
                  builder: (context, state) {
                    return state.date.valid &&
                            state.fromTime.valid &&
                            state.toTime.valid
                        ? CustomText(
                            text: CommonUtils.combineDateToTime(
                                state.date.value!,
                                state.fromTime.value!.format(context),
                                state.toTime.value!.format(context)),
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                            fontSize:
                                BookingStartLayoutConstants.inputFontSize.sp,
                          )
                        : CustomText(
                            text: BookingStartLayoutConstants.timeHintText,
                            color: AppColors.greyFF9098B1,
                            fontSize:
                                BookingStartLayoutConstants.inputFontSize.sp,
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
            SubmittedButton(
              title: BookingStartLayoutConstants.firstButtonTitle,
              onPressed: (context) => () {
                Navigator.of(context).pushNamed(Routes.bookingBulky);
              },
            ),
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

  Function()? _onPlaceInputTapped(BuildContext context) {
    return () {
      Navigator.pushNamed(context, Routes.bookingLocationPicker);
    };
  }

  void showTimeInputDialog(BuildContext context) {
    DateTime? date;
    TimeOfDay? fromTime, toTime;

    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<BookingTimeBloc, BookingTimeState>(
          builder: (context, state) {
            date = state.date.value;
            fromTime = state.fromTime.value;
            toTime = state.toTime.value;
            return const _TimeInputDialog();
          },
        );
      },
    ).then((value) {
      if (value == null) return;
      if (value) {
        context.read<BookingBloc>().add(
              BookingTimePicked(
                date: date ?? DateTime.now(),
                toTime: toTime ?? TimeOfDay.now(),
                fromTime: fromTime ?? TimeOfDay.now(),
              ),
            );
      }
    });
  }
}

class _AlertDialog extends StatelessWidget {
  const _AlertDialog({Key? key, required this.content}) : super(key: key);
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: content,
      actions: <Widget>[
        _getButton('HỦY', false, context),
        _getButton('XÁC NHẬN', true, context),
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

  Widget _getButton(String name, bool value, BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.of(context).pop(value),
      child: _getText(name),
    );
  }
}

class _TimeInputDialog extends StatelessWidget {
  const _TimeInputDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _AlertDialog(
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
                        BlocBuilder<BookingTimeBloc, BookingTimeState>(
                          builder: (context, state) {
                            return _getText(
                              CommonUtils.combineDateToTime(
                                  state.date.value!,
                                  state.fromTime.value!.format(context),
                                  state.toTime.value!.format(context)),
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
            BlocBuilder<BookingTimeBloc, BookingTimeState>(
              builder: (context, state) {
                return InkWell(
                  onTap:
                      _onDateTap(context, state.date.value ?? DateTime.now()),
                  child: _container(
                    Row(
                      children: <Widget>[
                        _getIcon(
                          Icons.date_range_outlined,
                        ),
                        Expanded(
                          child: BlocBuilder<BookingTimeBloc, BookingTimeState>(
                            builder: (context, state) {
                              return _getText(
                                CommonUtils.convertDateTimeToVietnamese(
                                  state.date.value,
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
                        BlocBuilder<BookingTimeBloc, BookingTimeState>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: _onTimeTap(context, state.fromTime.value!,
                                  _onFromTimeEvent),
                              child: _getTimeText(
                                state.fromTime.value!.format(context),
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
                        BlocBuilder<BookingTimeBloc, BookingTimeState>(
                          builder: (context, state) {
                            return InkWell(
                              onTap: _onTimeTap(
                                  context, state.toTime.value!, _onToTimeEvent),
                              child: _getTimeText(
                                state.toTime.value!.format(context),
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
          ],
        ),
      ),
    );
  }

  Function() _onCloseIconPressed(BuildContext context) {
    return () {
      Navigator.of(context).popUntil(
        ModalRoute.withName(Routes.bookingStart),
      );
    };
  }

  Function() _onDateTap(BuildContext context, DateTime init) {
    return () async {
      var now = DateTime.now();
      var result = await showDatePicker(
        context: context,
        initialDate: init,
        firstDate: now,
        lastDate: now.add(
          const Duration(days: 7),
        ),
        locale: const Locale(
          Symbols.vietnamLanguageCode,
          Symbols.vietnamISOCode,
        ),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        confirmText: 'XÁC NHẬN',
      );

      context.read<BookingTimeBloc>().add(
            BookingTimeDatePicked(result ?? DateTime.now()),
          );
    };
  }

  void _onFromTimeEvent(BuildContext context, DateTime dateTime) {
    context.read<BookingTimeBloc>().add(BookingTimeTimeFromPicked(dateTime));
  }

  void _onToTimeEvent(BuildContext context, DateTime dateTime) {
    context.read<BookingTimeBloc>().add(BookingTimeTimeToPicked(dateTime));
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
                minuteInterval: BookingMapPickerLayoutConstants.minuteInterval,
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
        vertical: 15.sp,
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
            offset: Offset(2.5, 5),
            blurRadius: 3,
            spreadRadius: -5.5,
          ),
        ],
        border: Border.all(
          color: AppColors.greyFF9098B1,
        ),
        borderRadius: BorderRadius.circular(
          15.0.r,
        ),
      ),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              right: 30.w,
            ),
            child: Icon(
              iconData,
              color: AppColors.greenFF61C53D,
              size: 55.sp,
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
    return BlocBuilder<BookingBloc, BookingState>(
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
            hintText: BookingStartLayoutConstants.noteHintText,
          ),
          textInputAction: TextInputAction.done,
          onChanged: (value) {
            context.read<BookingBloc>().add(BookingNoteChanged(value));
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
            text: BookingStartLayoutConstants.title,
            fontSize: 65.sp,
            fontWeight: FontWeight.w500,
          ),
          const CustomText(
            text: BookingStartLayoutConstants.subTitle,
          ),
        ],
      ),
    );
  }
}
