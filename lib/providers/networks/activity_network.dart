import 'package:http/http.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/providers/networks/models/response/activity_list_response_model.dart';
import 'package:seller_app/utils/common_utils.dart';

abstract class ActivityNetwork {
  Future<ActivityListResponseModel> activityGet(
    int status,
    int size,
    int page,
    Client client,
  );
}

class ActivityNetworkImpl implements ActivityNetwork {
  @override
  Future<ActivityListResponseModel> activityGet(
    int status,
    int size,
    int page,
    Client client,
  ) async {
    var responseModel = ActivityListResponseModel(resData: []);

    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.activityGet,
      client: client,
      queries: {
        'Status': status.toString(),
        'PageSize': size.toString(),
        'Page': page.toString(),
      },
    );
    // get model
    responseModel = await NetworkUtils
        .checkSuccessStatusCodeAPIMainResponseModel<ActivityListResponseModel>(
      response,
      activityListResponseModelFromJson,
    );
    return responseModel;
  }
}
