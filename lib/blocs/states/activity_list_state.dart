part of '../activity_list_bloc.dart';

enum ActivityListStatus {
  pure,
  progress,
  completed,
  error,
  emptyList,
}

// ignore: must_be_immutable
class ActivityListState extends Equatable {
  ActivityListState({
    List<Activity>? listActivity,
    required this.activityStatus,
    this.status = ActivityListStatus.pure,
    this.refreshStatus = RefreshStatus.idle,
  }) {
    this.listActivity = listActivity ?? [];
  }

  late List<Activity> listActivity;
  final int activityStatus;
  final ActivityListStatus status;
  final RefreshStatus refreshStatus;

  ActivityListState copyWith({
    List<Activity>? listActivity,
    int? activityStatus,
    ActivityListStatus? status,
    RefreshStatus? refreshStatus,
  }) {
    return ActivityListState(
      listActivity: listActivity ?? this.listActivity,
      activityStatus: activityStatus ?? this.activityStatus,
      status: status ?? this.status,
      refreshStatus: refreshStatus ?? this.refreshStatus,
    );
  }

  @override
  List<Object> get props => [
        listActivity,
        activityStatus,
        status,
        refreshStatus,
      ];
}

// ignore: must_be_immutable
class Activity extends Equatable {
  Activity({
    required this.collectingRequestId,
    required this.collectingRequestCode,
    required this.collectingRequestDate,
    required this.fromTime,
    required this.toTime,
    required this.status,
    required this.isBulky,
    required this.addressName,
    this.total,
  });

  String collectingRequestId;
  String collectingRequestCode;
  String collectingRequestDate;
  String fromTime;
  String toTime;
  int status;
  bool isBulky;
  String addressName;
  dynamic total;

  @override
  List<Object?> get props => [
        collectingRequestId,
        collectingRequestCode,
        collectingRequestDate,
        fromTime,
        toTime,
        status,
        isBulky,
        addressName,
        total,
      ];
}