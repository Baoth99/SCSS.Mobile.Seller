part of '../feedback_transaction_bloc.dart';

class FeedbackTransactionState extends Equatable {
  const FeedbackTransactionState({
    required this.transactionId,
    required this.rate,
    this.review = Symbols.empty,
    this.status = FormzStatus.pure,
  });

  final String transactionId;
  final double rate;
  final String review;
  final FormzStatus status;

  FeedbackTransactionState copyWith({
    double? rate,
    String? review,
    FormzStatus? status,
  }) {
    return FeedbackTransactionState(
      transactionId: transactionId,
      rate: rate ?? this.rate,
      review: review ?? this.review,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [
        transactionId,
        rate,
        review,
        status,
      ];
}
