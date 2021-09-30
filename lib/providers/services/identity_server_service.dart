import 'package:http/http.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/networks/identity_server_network.dart';
import 'package:seller_app/providers/networks/models/request/connect_revocation_request_model.dart';
import 'package:seller_app/providers/networks/models/request/connect_token_request_model.dart';
import 'package:seller_app/providers/networks/models/response/connect_token_response_model.dart';
import 'package:seller_app/providers/services/models/get_token_service_model.dart';
import 'package:seller_app/utils/common_utils.dart';

abstract class IdentityServerService {
  Future<GetTokenServiceModel> getToken(
    String username,
    String password,
  );
  Future<bool> connectRevocation();

  Future<bool> refreshToken();
}

class IdentityServerServiceImpl implements IdentityServerService {
  late IdentityServerNetwork _identityServerNetwork;

  IdentityServerServiceImpl({IdentityServerNetwork? identityServerNetwork}) {
    _identityServerNetwork =
        identityServerNetwork ?? getIt.get<IdentityServerNetwork>();
  }

  @override
  Future<GetTokenServiceModel> getToken(
    String username,
    String password,
  ) async {
    //create raw
    var serviceModel = const GetTokenServiceModel();

    var client = Client();
    //take responseMOdel
    var responseModel = await _identityServerNetwork
        .connectToken(
      ConnectTokenRequestModel(
        username: username,
        password: password,
      ),
      client,
    )
        .whenComplete(() {
      client.close();
    });

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

  @override
  Future<bool> connectRevocation() async {
    Client client = Client();
    var result = false;
    try {
      // revoke future access toekn;
      var resultRevokeAccessToken =
          SharedPreferenceUtils.getString(APIKeyConstants.accessToken)
              .then((value) async {
        if (value != null && value.isNotEmpty) {
          return await _identityServerNetwork.connectRevocation(
            ConnectRevocationRequestModel(
              token: value,
              tokenTypeHint: IdentityAPIConstants.accessToken,
            ),
            client,
          );
        }
      }).onError((error, stackTrace) => false);

      // revoke future refresh toekn;
      var resultRevokeRefreshToken =
          SharedPreferenceUtils.getString(APIKeyConstants.refreshToken)
              .then((value) async {
        if (value != null && value.isNotEmpty) {
          return await _identityServerNetwork.connectRevocation(
            ConnectRevocationRequestModel(
              token: value,
              tokenTypeHint: IdentityAPIConstants.refreshToken,
            ),
            client,
          );
        }
      }).onError((error, stackTrace) => false);

      // result
      result = (await resultRevokeAccessToken ?? false) &&
          (await resultRevokeRefreshToken ?? false);
    } finally {
      client.close();
    }
    return result;
  }

  @override
  Future<bool> refreshToken() async {
    Client client = Client();
    //get refresh Token
    String? refreshToken =
        await SharedPreferenceUtils.getString(APIKeyConstants.refreshToken);

    if (refreshToken != null) {
      if (refreshToken.isNotEmpty) {
        // call take token
        var responseModel = await _identityServerNetwork
            .refreshToken(refreshToken, client)
            .whenComplete(
              () => client.close(),
            );

        // set again in share prefrence
        if (responseModel.accessToken != null &&
            responseModel.accessToken!.isNotEmpty &&
            responseModel.refreshToken != null &&
            responseModel.refreshToken!.isNotEmpty) {
          var fAccessToken = SharedPreferenceUtils.setString(
              APIKeyConstants.accessToken, responseModel.accessToken!);

          var fRefreshToken = SharedPreferenceUtils.setString(
              APIKeyConstants.refreshToken, responseModel.refreshToken!);

          return (await fAccessToken && await fRefreshToken);
        }
      }
    }
    return false;
  }
}
