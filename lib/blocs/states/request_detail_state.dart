part of '../request_detail_bloc.dart';

class RequestDetailState extends Equatable {
  RequestDetailState({
    required this.id,
    this.createdDate = Symbols.empty,
    this.createdTime = Symbols.empty,
    this.collectingRequestCode = Symbols.empty,
    this.status = 0,
    this.collectorName = Symbols.empty,
    this.collectorPhoneNumber = Symbols.empty,
    this.collectorRating = 0,
    this.collectorAvatarUrl = Symbols.empty,
    this.addressName = Symbols.empty,
    this.address = Symbols.empty,
    this.collectingRequestDate = Symbols.empty,
    this.fromTime = Symbols.empty,
    this.toTime = Symbols.empty,
    this.approvedDate = Symbols.empty,
    this.approvedTime = Symbols.empty,
    this.isBulky = false,
    this.scrapCategoryImageUrl,
    this.note = Symbols.empty,
    this.transactionId = Symbols.empty,
    List<TransactionItem>? transaction,
    this.itemTotal = 0,
    this.serviceFee = 0,
    this.point = 0,
    this.billTotal = 0,
    this.doneActivityDate = Symbols.empty,
    this.doneActivityTime = Symbols.empty,
    this.isCancelable = false,
    this.cancelReason = Symbols.empty,
    this.stateStatus = FormzStatus.pure,
    this.feedbackStatus = 0,
    this.ratingFeedback = 0,
    this.feedbackToSystemInfo = const FeedbackToSystemInfo(),
  }) {
    this.transaction = transaction ?? [];
  }

  String id;
  String createdDate;
  String createdTime;
  String collectingRequestCode;
  int status;

  String collectorName;
  String collectorPhoneNumber;
  double collectorRating;
  String collectorAvatarUrl;
  String addressName;
  String address;
  String collectingRequestDate;
  String fromTime;
  String toTime;
  String approvedDate;
  String approvedTime;
  bool isBulky;
  String? scrapCategoryImageUrl;
  String note;
  String transactionId;
  late List<TransactionItem> transaction;
  int itemTotal;
  int serviceFee;
  int point;
  int billTotal;
  String doneActivityDate;
  String doneActivityTime;
  bool isCancelable;
  String cancelReason;
  int feedbackStatus;
  double ratingFeedback;
  FeedbackToSystemInfo feedbackToSystemInfo;
  FormzStatus stateStatus;

  RequestDetailState copyWith({
    String? createdDate,
    String? createdTime,
    String? collectingRequestCode,
    int? status,
    double? ratingStar,
    String? collectorName,
    String? collectorPhoneNumber,
    double? collectorRating,
    String? collectorAvatarUrl,
    String? addressName,
    String? address,
    String? collectingRequestDate,
    String? fromTime,
    String? toTime,
    String? approvedDate,
    String? approvedTime,
    bool? isBulky,
    String? scrapCategoryImageUrl,
    String? note,
    transactionId,
    List<TransactionItem>? transaction,
    int? itemTotal,
    int? serviceFee,
    int? point,
    int? billTotal,
    String? doneActivityDate,
    String? doneActivityTime,
    bool? isCancelable,
    String? cancelReason,
    int? feedbackStatus,
    int? feedbackType,
    double? ratingFeedback,
    FeedbackToSystemInfo? feedbackToSystemInfo,
    FormzStatus? stateStatus,
  }) {
    var state = RequestDetailState(
      id: id,
      createdDate: createdDate ?? this.createdDate,
      createdTime: createdTime ?? this.createdTime,
      collectingRequestCode:
          collectingRequestCode ?? this.collectingRequestCode,
      status: status ?? this.status,
      collectorName: collectorName ?? this.collectorName,
      collectorPhoneNumber: collectorPhoneNumber ?? this.collectorPhoneNumber,
      collectorRating: collectorRating ?? this.collectorRating,
      collectorAvatarUrl: collectorAvatarUrl ?? this.collectorAvatarUrl,
      addressName: addressName ?? this.addressName,
      address: address ?? this.address,
      collectingRequestDate:
          collectingRequestDate ?? this.collectingRequestDate,
      fromTime: fromTime ?? this.fromTime,
      toTime: toTime ?? this.toTime,
      approvedDate: approvedDate ?? this.approvedDate,
      approvedTime: approvedTime ?? this.approvedTime,
      isBulky: isBulky ?? this.isBulky,
      scrapCategoryImageUrl:
          scrapCategoryImageUrl ?? this.scrapCategoryImageUrl,
      note: note ?? this.note,
      transactionId: transactionId ?? this.transactionId,
      transaction: transaction ?? this.transaction,
      itemTotal: itemTotal ?? this.itemTotal,
      serviceFee: serviceFee ?? this.serviceFee,
      point: point ?? this.point,
      billTotal: billTotal ?? this.billTotal,
      doneActivityDate: doneActivityDate ?? this.doneActivityDate,
      doneActivityTime: doneActivityTime ?? this.doneActivityTime,
      isCancelable: isCancelable ?? this.isCancelable,
      cancelReason: cancelReason ?? this.cancelReason,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      ratingFeedback: ratingFeedback ?? this.ratingFeedback,
      feedbackToSystemInfo: feedbackToSystemInfo ?? this.feedbackToSystemInfo,
      stateStatus: stateStatus ?? this.stateStatus,
    );
    return state;
  }

  @override
  List<Object?> get props => [
        id,
        createdDate,
        createdTime,
        collectingRequestCode,
        status,
        collectorName,
        collectorPhoneNumber,
        collectorRating,
        collectorAvatarUrl,
        addressName,
        address,
        collectingRequestDate,
        fromTime,
        toTime,
        approvedDate,
        approvedTime,
        isBulky,
        scrapCategoryImageUrl,
        note,
        transactionId,
        transaction,
        itemTotal,
        serviceFee,
        point,
        billTotal,
        doneActivityDate,
        doneActivityTime,
        isCancelable,
        cancelReason,
        feedbackStatus,
        ratingFeedback,
        feedbackToSystemInfo,
        stateStatus,
      ];
}

class TransactionItem extends Equatable {
  TransactionItem({
    this.name = Symbols.empty,
    this.unitInfo = '-',
    this.quantity = 0,
    required this.total,
  });
  String name;
  String unitInfo;
  int quantity;
  int total;

  @override
  List<Object> get props => [
        name,
        unitInfo,
        quantity,
        total,
      ];
}

class FeedbackToSystemInfo extends Equatable {
  final int feedbackStatus;
  final String sellingFeedback;
  final String adminReply;

  const FeedbackToSystemInfo({
    this.feedbackStatus = 0,
    this.sellingFeedback = Symbols.empty,
    this.adminReply = Symbols.empty,
  });

  FeedbackToSystemInfo copyWith({
    int? feedbackStatus,
    String? sellingFeedback,
    String? adminReply,
  }) {
    return FeedbackToSystemInfo(
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      sellingFeedback: sellingFeedback ?? this.sellingFeedback,
      adminReply: adminReply ?? this.adminReply,
    );
  }

  @override
  List<Object> get props => [
        feedbackStatus,
        sellingFeedback,
        adminReply,
      ];
}
