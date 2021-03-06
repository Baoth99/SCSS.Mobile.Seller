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
    this.complaint = const Complaint(),
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
  Complaint complaint;
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
    Complaint? complaint,
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
      complaint: complaint ?? this.complaint,
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
        complaint,
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
  double quantity;
  int total;

  @override
  List<Object> get props => [
        name,
        unitInfo,
        quantity,
        total,
      ];
}

class Complaint extends Equatable {
  final int complaintStatus;
  final String complaintContent;
  final String adminReply;

  const Complaint({
    this.complaintStatus = 0,
    this.complaintContent = Symbols.empty,
    this.adminReply = Symbols.empty,
  });

  Complaint copyWith({
    int? complaintStatus,
    String? complaintContent,
    String? adminReply,
  }) {
    return Complaint(
      complaintStatus: complaintStatus ?? this.complaintStatus,
      complaintContent: complaintContent ?? this.complaintContent,
      adminReply: adminReply ?? this.adminReply,
    );
  }

  @override
  List<Object> get props => [
        complaintStatus,
        complaintContent,
        adminReply,
      ];
}
