part of '../booking_location_picker_bloc.dart';

abstract class BookingLocationPickerEvent extends AbstractEvent {
  const BookingLocationPickerEvent();
}

class BookingLocationPickerSearchChanged extends BookingLocationPickerEvent {
  const BookingLocationPickerSearchChanged(
    this.searchValue,
  );

  final String searchValue;

  @override
  List<String> get props => [
        searchValue,
      ];
}
