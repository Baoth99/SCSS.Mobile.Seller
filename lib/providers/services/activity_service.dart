import 'package:http/http.dart';
import 'package:seller_app/blocs/activity_list_bloc.dart';
import 'package:seller_app/blocs/request_detail_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/networks/activity_network.dart';
import 'package:seller_app/providers/networks/models/request/create_comlaint_request_model.dart';
import 'package:seller_app/providers/networks/models/request/feedback_transaction_requets_model.dart';
import 'package:seller_app/utils/extension_methods.dart';
import 'package:seller_app/utils/extension_methods.dart';

abstract class ActivityService {
  Future<List<Activity>> getListActivityByStatus(
    int status,
    int size,
    int page,
  );

  Future<RequestDetailState?> getRequetsDetail(String id);

  Future<bool> feedbackAdmin(String requetsId, String sellingFeedback);
  Future<bool> feedbackTransaction(
      String transactionId, double rate, String sellingReview);

  Future<Activity?> getNearestApprovedRequets();
}

class ActivityServiceImpl implements ActivityService {
  ActivityServiceImpl({
    ActivityNetwork? activityNetwork,
  }) {
    _activityNetwork = activityNetwork ?? getIt.get<ActivityNetwork>();
  }
  late ActivityNetwork _activityNetwork;

  @override
  Future<List<Activity>> getListActivityByStatus(
    int status,
    int size,
    int page,
  ) async {
    Client client = Client();

    var responseModel = await _activityNetwork
        .activityGet(
          status,
          size,
          page,
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var result = <Activity>[];
    if (responseModel.resData.isNotEmpty) {
      for (var m in responseModel.resData) {
        result.add(
          Activity(
            collectingRequestId: m.collectingRequestId,
            collectingRequestCode: m.collectingRequestCode,
            collectingRequestDate:
                m.collectingRequestDate.toVietnameseStringNotYear(),
            doneActivityTime:
                m.doneActivityTime?.toVietnameseStringNotYearHaveTime() ??
                    Symbols.empty,
            fromTime: m.fromTime,
            toTime: m.toTime,
            status: m.status,
            isBulky: m.isBulky,
            addressName: m.addressName,
            address: m.address,
            total: m.total,
          ),
        );
      }
    }

    return result;
  }

  @override
  Future<RequestDetailState?> getRequetsDetail(String id) async {
    Client client = Client();
    var responseModel = await _activityNetwork
        .activityDetail(
          id,
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var d = responseModel.resData;
    if (d != null) {
      var result = RequestDetailState(
        id: d.id,
        createdDate: d.createdDate,
        createdTime: d.createdTime,
        collectingRequestCode: d.collectingRequestCode,
        status: d.status,
        addressName: d.addressName,
        address: d.address,
        collectingRequestDate: d.collectingRequestDate,
        fromTime: d.fromTime,
        toTime: d.toTime,
        isBulky: d.isBulky,
        approvedDate: d.approvedDate ?? Symbols.empty,
        approvedTime: d.approvedTime ?? Symbols.empty,
        // collectorInfo: d.collectorInfo,
        doneActivityDate: d.doneActivityDate ?? Symbols.empty,
        doneActivityTime: d.doneActivityTime ?? Symbols.empty,
        note: d.note ?? Symbols.empty,
        scrapCategoryImageUrl: d.scrapCategoryImageUrl,
        transaction: d.transaction?.details
            .map(
              (e) => TransactionItem(
                name: e.scrapCategoryName ?? Symbols.empty,
                unitInfo: e.unit ?? Symbols.empty,
                quantity: e.quantity ?? 0,
                total: e.total,
              ),
            )
            .toList(),
        isCancelable: d.isCancelable,
        billTotal: (d.transaction?.total ?? 0) - (d.transaction?.fee ?? 0),
        point: d.transaction?.awardPoint ?? 0,
        serviceFee: d.transaction?.fee ?? 0,
        itemTotal: d.transaction?.total ?? 0,
        collectorName: d.collectorInfo?.name ?? Symbols.empty,
        collectorRating: d.collectorInfo?.rating ?? 0,
        collectorPhoneNumber: d.collectorInfo?.phone ?? Symbols.empty,
        collectorAvatarUrl: d.collectorInfo?.imageUrl ?? Symbols.empty,
        feedbackStatus: d.transaction?.feedbackInfo.feedbackStatus ?? 0,
        ratingFeedback: d.transaction?.feedbackInfo.ratingFeedback ?? 0,
        cancelReason: d.cancelReasoin ?? Symbols.empty,
        complaint: Complaint(
          complaintStatus: d.complaint.complaintStatus,
          complaintContent: d.complaint.complaintContent ?? Symbols.empty,
          adminReply: d.complaint.adminReply ?? Symbols.empty,
        ),
        transactionId: d.transaction?.transactionId ?? Symbols.empty,
      );
      return result;
    }
    return null;
  }

  @override
  Future<bool> feedbackAdmin(String requetsId, String complaint) async {
    Client client = Client();
    var result = await _activityNetwork
        .createComplaint(
            CreateComplaintequestModel(
                collectingRequestId: requetsId, complaintContent: complaint),
            client)
        .whenComplete(() => client.close());

    return result.isSuccess! && result.statusCode == NetworkConstants.ok200;
  }

  @override
  Future<bool> feedbackTransaction(
      String transactionId, double rate, String sellingReview) async {
    Client client = Client();
    var responseModel = await _activityNetwork
        .feedbackTransaction(
          FeedbackTransactionRequestModel(
              sellCollectTransactionId: transactionId,
              rate: rate,
              sellingReview: sellingReview),
          client,
        )
        .whenComplete(() => client.close());

    return responseModel.isSuccess! &&
        responseModel.statusCode == NetworkConstants.ok200;
  }

  @override
  Future<Activity?> getNearestApprovedRequets() async {
    Client client = Client();
    var reseponseModel =
        await _activityNetwork.getNearestApprovedRequest(client);

    var data = reseponseModel.resData;
    if (data != null) {
      return Activity(
        collectingRequestId: data.collectingRequestId,
        collectingRequestCode: data.collectingRequestCode,
        collectingRequestDate:
            data.collectingRequestDate.toVietnameseStringNotYear(),
        doneActivityTime: Symbols.empty,
        fromTime: data.fromTime,
        toTime: data.toTime,
        status: data.status,
        isBulky: data.isBulky,
        addressName: data.addressName,
        address: data.address,
      );
    }
    return null;
  }
}
