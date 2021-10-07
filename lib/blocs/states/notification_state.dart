part of '../notification_bloc.dart';

class NotificationState extends Equatable {
  const NotificationState({
    required this.listNotificationData,
    this.page = 0,
    this.loadStatus = LoadStatus.idle,
    this.refreshStatus = RefreshStatus.idle,
    this.screenStatus = FormzStatus.pure,
  });

  final List<NotificationData> listNotificationData;
  final int page;
  final LoadStatus loadStatus;
  final RefreshStatus refreshStatus;
  final FormzStatus screenStatus;

  NotificationState copyWith({
    List<NotificationData>? listNotificationData,
    int? page,
    LoadStatus? loadStatus,
    RefreshStatus? refreshStatus,
    FormzStatus? screenStatus,
  }) {
    return NotificationState(
      listNotificationData: listNotificationData ?? this.listNotificationData,
      page: page ?? this.page,
      loadStatus: loadStatus ?? this.loadStatus,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      screenStatus: screenStatus ?? this.screenStatus,
    );
  }

  @override
  List<Object> get props => [
        listNotificationData,
        page,
        loadStatus,
        refreshStatus,
        screenStatus,
      ];
}

class NotificationData extends Equatable {
  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    this.screenId,
    this.screenDataId,
    required this.isRead,
    required this.notiType,
    required this.time,
  });

  final String id;
  final String title;
  final String body;
  final int? screenId;
  final String? screenDataId;
  final bool isRead;
  final int notiType;
  final String time;

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        screenId,
        screenDataId,
        isRead,
        notiType,
        time,
      ];
}
