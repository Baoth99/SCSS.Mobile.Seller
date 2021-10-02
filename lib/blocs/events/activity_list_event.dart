part of '../activity_list_bloc.dart';

class ActivityListEvent extends AbstractEvent {
  const ActivityListEvent();
}

class ActivityListInitial extends ActivityListEvent {}

class ActivityListRetreived extends ActivityListEvent {}

class ActivityListRefresh extends ActivityListEvent {}
