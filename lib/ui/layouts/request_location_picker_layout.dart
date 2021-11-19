import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:seller_app/blocs/request_bloc.dart';
import 'package:seller_app/blocs/request_location_picker_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/ui/layouts/request_map_picker_layout.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class RequestLocationPickerArguments {
  final String intialValue;
  const RequestLocationPickerArguments(this.intialValue);
}

class RequestLocationPickerLayout extends StatelessWidget {
  const RequestLocationPickerLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FunctionalWidgets.buildAppBar(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        action: <Widget>[
          BlocBuilder<RequestBloc, RequestState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    Routes.requestMapPicker,
                    arguments: RequestMapPickerArgument(
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
      body: BlocProvider<RequestLocationPickerBloc>(
        create: (context) => RequestLocationPickerBloc(),
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
        as RequestLocationPickerArguments;
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
        context.read<RequestLocationPickerBloc>().add(
              RequestLocationPickerSearchChanged(value),
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
          context.read<RequestLocationPickerBloc>().add(
                RequestLocationPickerSearchChanged(value),
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
    return BlocBuilder<RequestLocationPickerBloc, RequestLocationPickerState>(
      builder: (context, state) {
        final predictions = state.predictions;

        return state.status.isSubmissionSuccess
            ? ListView.separated(
                itemBuilder: (context, index) => _MapResultTile(
                  placeId: predictions[index].placeId,
                  main: predictions[index].mainText,
                  sub: predictions[index].secondaryText,
                  district: predictions[index].district,
                  city: predictions[index].city,
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
      color: AppColors.greenFF01C971,
    );
  }
}

class _MapResultTile extends StatelessWidget {
  const _MapResultTile({
    Key? key,
    required this.main,
    required this.sub,
    required this.placeId,
    required this.district,
    required this.city,
  }) : super(key: key);
  final String main;
  final String sub;
  final String placeId;
  final String district;
  final String city;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestLocationPickerBloc, RequestLocationPickerState>(
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
      // add to bloc request
      context.read<RequestBloc>().add(
            RequestAddressTapped(
              placeId,
              district,
              city,
            ),
          );
      //pop
      Navigator.popUntil(
        context,
        ModalRoute.withName(Routes.requestStart),
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
