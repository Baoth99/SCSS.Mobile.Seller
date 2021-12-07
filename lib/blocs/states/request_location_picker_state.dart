part of '../request_location_picker_bloc.dart';

class AddressPrediction extends Equatable {
  const AddressPrediction({
    this.placeId = Symbols.empty,
    this.mainText = Symbols.empty,
    this.secondaryText = Symbols.empty,
    this.district = Symbols.empty,
    this.city = Symbols.empty,
  });

  final String placeId;
  final String mainText;
  final String secondaryText;
  final String district;
  final String city;

  @override
  List<String> get props => [
        placeId,
        mainText,
        secondaryText,
        district,
        city,
      ];
}

class RequestLocationPickerState extends Equatable {
  const RequestLocationPickerState({
    this.predictions = const [],
    this.status = FormzStatus.submissionSuccess,
    this.deleteLocationStatus = FormzStatus.pure,
  });

  final List<AddressPrediction> predictions;
  final FormzStatus status;
  final FormzStatus deleteLocationStatus;

  RequestLocationPickerState copyWith({
    List<AddressPrediction>? predictions,
    FormzStatus? status,
    FormzStatus? deleteLocationStatus,
  }) {
    return RequestLocationPickerState(
      predictions: predictions ?? this.predictions,
      status: status ?? this.status,
      deleteLocationStatus: deleteLocationStatus ?? this.deleteLocationStatus,
    );
  }

  @override
  List<Object> get props => [
        predictions,
        status,
        deleteLocationStatus,
      ];
}
