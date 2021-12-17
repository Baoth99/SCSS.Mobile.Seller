import 'package:json_annotation/json_annotation.dart';

part 'predict_place_goong_map_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PredictPlaceGoongMapResponseModel {
  final List<_Prediction> predictions;
  final int executedTime;
  final int executedTimeAll;
  final String status;

  PredictPlaceGoongMapResponseModel(
      this.predictions, this.executedTime, this.executedTimeAll, this.status);

  factory PredictPlaceGoongMapResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$PredictPlaceGoongMapResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PredictPlaceGoongMapResponseModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class _Prediction {
  final String description;
  final String placeId;
  final String reference;
  final _StructuredFormatting structuredFormatting;
  final Compound compound;

  _Prediction(
    this.description,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.compound,
  );

  factory _Prediction.fromJson(Map<String, dynamic> json) =>
      _$_PredictionFromJson(json);
  Map<String, dynamic> toJson() => _$_PredictionToJson(this);
}

class Compound {
  Compound({
    required this.district,
    required this.commune,
    required this.province,
  });

  String district;
  String commune;
  String province;

  factory Compound.fromJson(Map<String, dynamic> json) => Compound(
        district: json["district"],
        commune: json["commune"],
        province: json["province"],
      );
}

@JsonSerializable(fieldRename: FieldRename.snake)
class _StructuredFormatting {
  final String mainText;
  final String secondaryText;

  _StructuredFormatting(this.mainText, this.secondaryText);

  factory _StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      _$_StructuredFormattingFromJson(json);

  Map<String, dynamic> toJson() => _$_StructuredFormattingToJson(this);
}
