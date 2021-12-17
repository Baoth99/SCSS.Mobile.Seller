part of '../feedback_transaction_bloc.dart';

abstract class FeedbackTransactionEvent extends AbstractEvent {
  const FeedbackTransactionEvent();
}

class FeedbackReviewChanged extends FeedbackTransactionEvent {
  const FeedbackReviewChanged(this.review);

  final String review;

  @override
  List<String> get props => [review];
}

class FeedbackRateChanged extends FeedbackTransactionEvent {
  const FeedbackRateChanged(this.rate);

  final double rate;

  @override
  List<double> get props => [rate];
}

class FeedbackTransactionSubmmited extends FeedbackTransactionEvent {}
