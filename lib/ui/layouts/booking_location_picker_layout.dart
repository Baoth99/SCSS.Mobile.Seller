import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_app/blocs/booking_bloc.dart';
import 'package:seller_app/blocs/booking_location_picker_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/layouts/booking_map_picker_layout.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BookingLocationPickerArguments {
  final String intialValue;
  const BookingLocationPickerArguments(this.intialValue);
}

class BookingLocationPickerLayout extends StatelessWidget {
  const BookingLocationPickerLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        action: <Widget>[
          BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    Routes.bookingMapPicker,
                    arguments: BookingMapPickerArgument(
                      lat: state.address.value.latitude,
                      log: state.address.value.longitude,
                    ),
                  );
                },
                icon: Icon(
                  Icons.map_outlined,
                  size: 60.sp,
                ),
              );
            },
          )
        ],
      ),
      body: BlocProvider<BookingLocationPickerBloc>(
        create: (context) => BookingLocationPickerBloc(),
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
      children: [
        const _SearchField(),
        Divider(
          color: AppColors.greyFFEEEEEE,
          thickness: 15.0.h,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: AppConstants.horizontalScaffoldMargin.w),
            child: const _MapResult(),
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField({Key? key}) : super(key: key);

  @override
  __SearchFieldState createState() => __SearchFieldState();
}

class __SearchFieldState extends State<_SearchField> {
  //inorder to prevent api call continuously
  Timer? _debounce;
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as BookingLocationPickerArguments;
    return TextFormField(
      initialValue: args.intialValue,
      autofocus: true,
      style: TextStyle(
        fontSize: 60.sp,
        fontWeight: FontWeight.w500,
      ),
      decoration: const InputDecoration(
        border: InputBorder.none,
        prefixIcon: Icon(
          AppIcons.place,
          color: AppColors.orangeFFF5670A,
        ),
        hintText: 'Đặt hẹn ở đâu?',
      ),
      onChanged: _onChanged(context),
      textInputAction: TextInputAction.search,
      onFieldSubmitted: (value) {
        context.read<BookingLocationPickerBloc>().add(
              BookingLocationPickerSearchChanged(value),
            );
      },
    );
  }

  Function(String)? _onChanged(BuildContext context) {
    return (value) {
      // check if _debounce exist
      if (_debounce?.isActive ?? false) _debounce!.cancel();
      _debounce = Timer(
        const Duration(milliseconds: 1500),
        () {
          context.read<BookingLocationPickerBloc>().add(
                BookingLocationPickerSearchChanged(value),
              );
        },
      );
    };
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

class _MapResult extends StatelessWidget {
  const _MapResult({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingLocationPickerBloc, BookingLocationPickerState>(
      builder: (context, state) {
        final predictions = state.predictions;

        return state.status.isSubmissionSuccess
            ? ListView.separated(
                itemBuilder: (context, index) => _MapResultTile(
                  placeId: predictions[index].placeId,
                  main: predictions[index].mainText,
                  sub: predictions[index].secondaryText,
                ),
                separatorBuilder: (context, index) => Divider(
                  color: AppColors.greyFFEEEEEE,
                  thickness: 5.0.h,
                ),
                itemCount: predictions.length,
              )
            : state.status.isSubmissionInProgress
                ? getLoadingAnimation()
                : Icon(
                    Icons.error,
                    size: 180.sp,
                    color: AppColors.red,
                  );
      },
    );
  }

  Widget getLoadingAnimation() {
    return const SpinKitRing(
      color: AppColors.greenFF61C53D,
    );
  }
}

class _MapResultTile extends StatelessWidget {
  const _MapResultTile(
      {Key? key, required this.main, required this.sub, required this.placeId})
      : super(key: key);
  final String main;
  final String sub;
  final String placeId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingLocationPickerBloc, BookingLocationPickerState>(
      builder: (context, state) {
        return InkWell(
          onTap: _onItemTap(
            context,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
              vertical: 15.h,
            ),
            height: 120.h,
            child: Row(
              children: <Widget>[
                _resultTileIcon(),
                Expanded(
                  child: _resultTileContent(main, sub, context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Function()? _onItemTap(BuildContext context) {
    return () {
      // add to bloc booking
      context.read<BookingBloc>().add(
            BookingAddressTapped(placeId),
          );
      //pop
      Navigator.popUntil(
        context,
        ModalRoute.withName(Routes.bookingStart),
      );
    };
  }

  static Widget _resultTileContent(
      String main, String sub, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          main,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 45.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          sub,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: 38.sp,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  static Widget _resultTileIcon() {
    return Container(
      margin: EdgeInsets.only(
        right: 40.w,
      ),
      width: 60.w,
      height: 60.h,
      alignment: Alignment.center,
      child: Icon(
        AppIcons.place,
        color: AppColors.white,
        size: 45.sp,
      ),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.black,
      ),
    );
  }
}
