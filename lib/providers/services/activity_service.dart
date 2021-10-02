import 'package:http/http.dart';
import 'package:seller_app/blocs/activity_list_bloc.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/networks/activity_network.dart';

abstract class ActivityService {
  Future<List<Activity>> getListActivityByStatus(int status);
}

class ActivityServiceImpl implements ActivityService {
  ActivityServiceImpl({
    ActivityNetwork? activityNetwork,
  }) {
    _activityNetwork = activityNetwork ?? getIt.get<ActivityNetwork>();
  }
  late ActivityNetwork _activityNetwork;

  @override
  Future<List<Activity>> getListActivityByStatus(int status) async {
    Client client = Client();

    var responseModel = await _activityNetwork
        .activityGet(
          status,
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
}
