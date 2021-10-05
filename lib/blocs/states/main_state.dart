part of '../main_bloc.dart';

class MainState extends Equatable {
  MainState({
    this.screenIndex = 0,
    this.isRequestFull,
    this.statusCreateRequest = FormzStatus.pure,
  });

  final int screenIndex;
  bool? isRequestFull;
  final FormzStatus statusCreateRequest;

  MainState copyWith({
    int? screenIndex,
    bool? isRequestFull,
    FormzStatus? statusCreateRequest,
  }) {
    return MainState(
      screenIndex: screenIndex ?? this.screenIndex,
      isRequestFull: isRequestFull ?? this.isRequestFull,
      statusCreateRequest: statusCreateRequest ?? this.statusCreateRequest,
    );
  }

  @override
  List<Object?> get props => [
        screenIndex,
        isRequestFull,
        statusCreateRequest,
      ];
}
