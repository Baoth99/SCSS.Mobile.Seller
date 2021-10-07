part of '../notification_bloc.dart';

class NotificationEvent extends AbstractEvent {
  const NotificationEvent();
}

class NotificationInitial extends NotificationEvent {}

class NotificationRefresh extends NotificationEvent {}

class NotificationLoading extends NotificationEvent {}
