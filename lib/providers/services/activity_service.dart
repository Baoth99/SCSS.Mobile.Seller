import 'package:http/http.dart';
import 'package:seller_app/blocs/activity_list_bloc.dart';
import 'package:seller_app/blocs/request_detail_bloc.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/networks/activity_network.dart';

abstract class ActivityService {
  Future<List<Activity>> getListActivityByStatus(
    int status,
    int size,
    int page,
  );

  Future<RequestDetailState?> getRequetsDetail(String id);
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
            collectingRequestDate: m.collectingRequestDate,
            fromTime: m.fromTime,
            toTime: m.toTime,
            status: m.status,
            isBulky: m.isBulky,
            addressName: m.addressName,
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
        transaction: d.transaction,
        isCancelable: d.isCancelable,
      );
      return result;
    }
    return null;
  }
}
