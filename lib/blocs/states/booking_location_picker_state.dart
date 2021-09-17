part of '../booking_location_picker_bloc.dart';

class AddressPrediction extends Equatable {
  const AddressPrediction({
    this.placeId = '',
    this.mainText = '',
    this.secondaryText = '',
  });

  final String placeId;
  final String mainText;
  final String secondaryText;

  @override
  List<String> get props => [
        placeId,
        mainText,
        secondaryText,
      ];
}

class BookingLocationPickerState extends Equatable {
  const BookingLocationPickerState({
    this.predictions = const [],
    this.status = FormzStatus.submissionSuccess,
  });

  final List<AddressPrediction> predictions;
  final FormzStatus status;

  BookingLocationPickerState copyWith({
    List<AddressPrediction>? predictions,
    FormzStatus? status,
  }) {
    return BookingLocationPickerState(
      predictions: predictions ?? this.predictions,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        predictions,
        status,
      ];
}
