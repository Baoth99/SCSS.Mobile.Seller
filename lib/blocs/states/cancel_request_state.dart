part of '../cancel_request_bloc.dart';

class CancelRequestState extends Equatable {
  const CancelRequestState({
    this.requestId = Symbols.empty,
    this.cancelReason = const CancelReason.pure(),
    this.status = FormzStatus.pure,
  });

  final String requestId;
  final CancelReason cancelReason;
  final FormzStatus status;

  CancelRequestState copyWith({
    CancelReason? cancelReason,
    FormzStatus? status,
  }) {
    return CancelRequestState(
      requestId: requestId,
      cancelReason: cancelReason ?? this.cancelReason,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        requestId,
        cancelReason,
        status,
      ];
}
