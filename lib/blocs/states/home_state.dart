part of '../home_bloc.dart';

enum APIFetchState {
  idle,
  fetching,
}

class HomeState extends Equatable {
  const HomeState({
    this.activity,
    this.status = FormzStatus.pure,
    this.apiState = APIFetchState.idle,
  });

  final Activity? activity;
  final FormzStatus status;
  final APIFetchState apiState;

  HomeState copyWith({
    FormzStatus? status,
    Activity? activity,
    APIFetchState? apiState,
  }) {
    return HomeState(
      status: status ?? this.status,
      activity: activity,
      apiState: apiState ?? this.apiState,
    );
  }

  @override
  List<Object?> get props => [
        status,
        activity,
        apiState,
      ];
}
