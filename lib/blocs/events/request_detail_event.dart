part of '../request_detail_bloc.dart';

class RequestDetailEvent extends AbstractEvent {
  const RequestDetailEvent();
}

class RequestDetailInitial extends RequestDetailEvent {}

class RequestDetailAfterCanceled extends RequestDetailEvent {}

class RequestDetailInitialTest extends RequestDetailEvent {}
