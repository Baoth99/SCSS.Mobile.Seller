part of '../request_detail_bloc.dart';

class RequestDetailState extends Equatable {
  RequestDetailState({
    required this.id,
    this.createdDate = Symbols.empty,
    this.createdTime = Symbols.empty,
    this.collectingRequestCode = Symbols.empty,
    this.status = 0,
    this.ratingStar,
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
    List<TransactionItem>? transaction,
    this.itemTotal = Symbols.empty,
    this.serviceFee = Symbols.empty,
    this.point = Symbols.empty,
    this.billTotal = Symbols.empty,
    this.doneActivityDate = Symbols.empty,
    this.doneActivityTime = Symbols.empty,
    this.isCancelable = false,
    this.stateStatus = FormzStatus.pure,
  }) {
    this.transaction = transaction ?? [];
  }

  String id;
  String createdDate;
  String createdTime;
  String collectingRequestCode;
  int status;
  double? ratingStar;
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
  late List<TransactionItem> transaction;
  String itemTotal;
  String serviceFee;
  String point;
  String billTotal;
  String doneActivityDate;
  String doneActivityTime;
  bool isCancelable;
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
    List<TransactionItem>? transaction,
    String? itemTotal,
    String? serviceFee,
    String? point,
    String? billTotal,
    String? doneActivityDate,
    String? doneActivityTime,
    bool? isCancelable,
    FormzStatus? stateStatus,
  }) {
    var state = RequestDetailState(
      id: id,
      createdDate: createdDate ?? this.createdDate,
      createdTime: createdTime ?? this.createdTime,
      collectingRequestCode:
          collectingRequestCode ?? this.collectingRequestCode,
      status: status ?? this.status,
      ratingStar: ratingStar ?? this.ratingStar,
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
      transaction: transaction ?? this.transaction,
      itemTotal: itemTotal ?? this.itemTotal,
      serviceFee: serviceFee ?? this.serviceFee,
      point: point ?? this.point,
      billTotal: billTotal ?? this.billTotal,
      doneActivityDate: doneActivityDate ?? this.doneActivityDate,
      doneActivityTime: doneActivityTime ?? this.doneActivityTime,
      isCancelable: isCancelable ?? this.isCancelable,
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
        ratingStar,
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
        transaction,
        itemTotal,
        serviceFee,
        point,
        billTotal,
        doneActivityDate,
        doneActivityTime,
        isCancelable,
        stateStatus,
      ];
}

class TransactionItem extends Equatable {
  TransactionItem({
    required this.name,
    this.unitInfo = '-',
    required this.total,
  });
  String name;
  String unitInfo;
  String total;

  @override
  List<String> get props => [
        name,
        unitInfo,
        total,
      ];
}
