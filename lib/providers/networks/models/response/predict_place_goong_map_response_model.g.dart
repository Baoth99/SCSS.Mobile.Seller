// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'predict_place_goong_map_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PredictPlaceGoongMapResponseModel _$PredictPlaceGoongMapResponseModelFromJson(
    Map<String, dynamic> json) {
  return PredictPlaceGoongMapResponseModel(
    (json['predictions'] as List<dynamic>)
        .map((e) => _Prediction.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['executed_time'] as int,
    json['executed_time_all'] as int,
    json['status'] as String,
  );
}

Map<String, dynamic> _$PredictPlaceGoongMapResponseModelToJson(
        PredictPlaceGoongMapResponseModel instance) =>
    <String, dynamic>{
      'predictions': instance.predictions.map((e) => e.toJson()).toList(),
      'executed_time': instance.executedTime,
      'executed_time_all': instance.executedTimeAll,
      'status': instance.status,
    };

_Prediction _$_PredictionFromJson(Map<String, dynamic> json) {
  return _Prediction(
    json['description'] as String,
    json['place_id'] as String,
    json['reference'] as String,
    _StructuredFormatting.fromJson(
        json['structured_formatting'] as Map<String, dynamic>),
    Compound.fromJson(json["compound"] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_PredictionToJson(_Prediction instance) =>
    <String, dynamic>{
      'description': instance.description,
      'place_id': instance.placeId,
      'reference': instance.reference,
      'structured_formatting': instance.structuredFormatting.toJson(),
    };

_StructuredFormatting _$_StructuredFormattingFromJson(
    Map<String, dynamic> json) {
  return _StructuredFormatting(
    json['main_text'] as String,
    json['secondary_text'] as String,
  );
}

Map<String, dynamic> _$_StructuredFormattingToJson(
        _StructuredFormatting instance) =>
    <String, dynamic>{
      'main_text': instance.mainText,
      'secondary_text': instance.secondaryText,
    };
