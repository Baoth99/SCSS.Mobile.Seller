import 'package:http/http.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/providers/networks/models/response/notification_get_response_model.dart';
import 'package:seller_app/utils/common_utils.dart';

abstract class NotificationNetwork {
  Future<NotificationGetResponseModel> getNotification(
    int page,
    int pageSize,
    Client client,
  );
}

class NotificationNetworkImpl extends NotificationNetwork {
  @override
  Future<NotificationGetResponseModel> getNotification(
    int page,
    int pageSize,
    Client client,
  ) async {
    NotificationGetResponseModel responseModel = NotificationGetResponseModel();

    var response = await NetworkUtils.getNetworkWithBearer(
      uri: APIServiceURI.notificationGet,
      client: client,
      queries: {
        'Page': page.toString(),
        'PageSize': pageSize.toString(),
      },
    );
    var result = await NetworkUtils.checkSuccessStatusCodeAPIMainResponseModel<
        NotificationGetResponseModel>(
      response,
      notificationGetResponseModelFromJson,
    );
    // get model
    responseModel = result;

    return responseModel;
  }
}
