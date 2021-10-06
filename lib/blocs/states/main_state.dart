part of '../main_bloc.dart';

class MainState extends Equatable {
  MainState({
    this.screenIndex = 0,
    this.isRequestFull,
    this.statusCreateRequest = FormzStatus.pure,
    this.activityIndex = 0,
  });

  final int screenIndex;
  bool? isRequestFull;
  final FormzStatus statusCreateRequest;
  final int activityIndex;

  MainState copyWith({
    int? screenIndex,
    bool? isRequestFull,
    FormzStatus? statusCreateRequest,
    int? activityIndex,
  }) {
    return MainState(
      screenIndex: screenIndex ?? this.screenIndex,
      isRequestFull: isRequestFull ?? this.isRequestFull,
      statusCreateRequest: statusCreateRequest ?? this.statusCreateRequest,
      activityIndex: activityIndex ?? this.activityIndex,
    );
  }

  @override
  List<Object?> get props => [
        screenIndex,
        isRequestFull,
        statusCreateRequest,
        activityIndex,
      ];
}
