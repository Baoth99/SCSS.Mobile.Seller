import 'package:mapbox_gl/mapbox_gl.dart';

class PredictPlaceGoongMapRequestModel {
  PredictPlaceGoongMapRequestModel({
    required this.predictValue,
    this.latitude,
    this.longitude,
  });

  final String predictValue;
  final double? latitude;
  final double? longitude;
}
