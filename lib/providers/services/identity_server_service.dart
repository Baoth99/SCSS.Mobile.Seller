import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/networks/identity_server_network.dart';
import 'package:seller_app/providers/networks/models/request/connect_token_request_model.dart';
import 'package:seller_app/providers/networks/models/response/connect_token_response_model.dart';
import 'package:seller_app/providers/services/models/get_token_service_model.dart';

abstract class IdentityServerService {
  Future<GetTokenServiceModel> getToken(String username, String password);
}

class IdentityServerServiceImpl implements IdentityServerService {
  final identityServerNetwork = getIt.get<IdentityServerNetwork>();

  @override
  Future<GetTokenServiceModel> getToken(
      String username, String password) async {
    //create raw
    var serviceModel = const GetTokenServiceModel();

    //take responseMOdel
    var responseModel = await identityServerNetwork.connectToken(
      ConnectTokenRequestModel(
        username: username,
        password: password,
      ),
    );

    //check responsemodel
    if (responseModel != null) {
      if (responseModel is ConnectToken200ResponseModel) {
        serviceModel = GetTokenServiceModel(
          accessToken: responseModel.accessToken,
          refreshToken: responseModel.refreshToken,
        );
      } else if (responseModel is ConnectToken400ResponseModel) {
        serviceModel = const GetTokenServiceModel(
          accessToken: Symbols.empty,
          refreshToken: Symbols.empty,
        );
      }
    }
    return serviceModel;
  }
}
