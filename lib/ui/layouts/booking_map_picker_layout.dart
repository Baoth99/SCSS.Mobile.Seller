import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:seller_app/blocs/booking_bloc.dart';
import 'package:seller_app/blocs/booking_map_picker_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/services/map_service.dart';
import 'package:seller_app/ui/widgets/custom_text_widget.dart';
import 'package:seller_app/ui/widgets/function_widgets.dart';
import 'package:seller_app/utils/env_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

class BookingMapPickerLayout extends StatelessWidget {
  const BookingMapPickerLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingMapPickerBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: FunctionalWidgets.buildAppBar(
          context: context,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: BlocBuilder<BookingMapPickerBloc, BookingMapPickerState>(
            builder: (context, state) {
              return CustomText(
                text: state.status.isSubmissionSuccess
                    ? state.placeName
                    : state.status.isSubmissionInProgress
                        ? 'Đang tải'
                        : state.status.isSubmissionFailure
                            ? 'Oops!'
                            : Symbols.empty,
              );
            },
          ),
        ),
        body: const _Body(),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: <Widget>[
        const _Map(),
        Image.asset(
          BookingMapPickerLayoutConstants.markerPath,
          width: 80.w,
        ),
        Positioned(
          bottom: 40.h,
          child: const _SubmittedButton(),
        ),
      ],
    );
  }
}

class _Map extends StatefulWidget {
  const _Map({Key? key}) : super(key: key);

  @override
  __MapState createState() => __MapState();
}

class __MapState extends State<_Map> {
  MapboxMapController? _mapController;
  CameraPosition? _cameraPosition;

  @override
  void dispose() {
    _mapController?.removeListener(_onMapChanged);
    //TODO; CHECK
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        MapboxMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(
              MapConstants.hoChiMinhLatitude,
              MapConstants.hoChiMinhLongitude,
            ),
            zoom: 15.0,
          ),
          accessToken: EnvMapSettingValue.accessToken,
          onMapCreated: _onMapCreated(context),
          trackCameraPosition: true,
          styleString: EnvMapSettingValue.mapStype,
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: false,
          zoomGesturesEnabled: true,
          myLocationEnabled: true,
          myLocationTrackingMode: MyLocationTrackingMode.None,
          myLocationRenderMode: MyLocationRenderMode.NORMAL,
          onCameraIdle: _onCameraIdle(context),
        ),
        Positioned(
          bottom: 250.h,
          right: 50.h,
          child: Container(
            child: IconButton(
              color: Colors.grey[600],
              icon: const Icon(Icons.my_location),
              onPressed: () {
                _animateCrurentLocation();
              },
            ),
            width: 150.w,
            height: 150.h,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  void Function(MapboxMapController) _onMapCreated(BuildContext context) {
    return (MapboxMapController controller) {
      _mapController = controller;
      _animateCrurentLocation();

      _mapController?.addListener(_onMapChanged);
    };
  }

  void _animateCrurentLocation() async {
    final latlng = await acquireCurrentLocation();
    if (latlng != null) {
      await _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(latlng.latitude, latlng.longitude),
        ),
      );
      await _mapController?.animateCamera(
        CameraUpdate.zoomTo(15),
      );
    }
  }

  void Function() _onCameraIdle(BuildContext context) {
    return () {
      var latLng = _cameraPosition?.target;
      if (latLng != null) {
        context.read<BookingMapPickerBloc>().add(
              BookingMapPickerMapChanged(
                latLng.latitude,
                latLng.longitude,
              ),
            );
      }
    };
  }

  void _onMapChanged() {
    _cameraPosition = _mapController?.cameraPosition;
  }
}

class _SubmittedButton extends StatelessWidget {
  const _SubmittedButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingMapPickerBloc, BookingMapPickerState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: AppColors.greenFF61C53D,
            minimumSize: Size(
              1000.w,
              WidgetConstants.buttonCommonHeight.h,
            ),
          ),
          onPressed: state.status.isSubmissionSuccess
              ? _onPressed(
                  context,
                  state.latitude,
                  state.longitude,
                  state.placeName,
                  state.address,
                )
              : null,
          child: CustomText(
            fontSize: WidgetConstants.buttonCommonFrontSize.sp,
            text: BookingMapPickerLayoutConstants.submittedButton,
          ),
        );
      },
    );
  }

  void Function() _onPressed(
    BuildContext context,
    double latitude,
    double longitude,
    String name,
    String address,
  ) {
    return () {
      context.read<BookingBloc>().add(
            BookingAddressPicked(
              latitude: latitude,
              longitude: longitude,
              name: name,
              address: address,
            ),
          );
      Navigator.popUntil(
        context,
        ModalRoute.withName(Routes.bookingStart),
      );
    };
  }
}
