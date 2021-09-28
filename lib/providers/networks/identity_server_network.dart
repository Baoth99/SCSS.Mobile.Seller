import 'dart:io';

import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/providers/networks/models/request/connect_revocation_request_model.dart';
import 'package:seller_app/providers/networks/models/request/connect_token_request_model.dart';
import 'package:seller_app/providers/networks/models/response/connect_token_response_model.dart';
import 'package:seller_app/utils/common_utils.dart';
import 'package:seller_app/utils/env_util.dart';

abstract class IdentityServerNetwork {
  Future<ConnectTokenResponseModel?> connectToken(
      ConnectTokenRequestModel requestModel);

  Future<bool> connectRevocation(ConnectRevocationRequestModel requestModel);
}

class IdentityServerNetworkImpl implements IdentityServerNetwork {
  @override
  Future<ConnectTokenResponseModel?> connectToken(
      ConnectTokenRequestModel requestModel) async {
    String scopeValue = CommonUtils.concatString(
      [
        EnvID4AppSettingValue.scopeResource,
        EnvID4AppSettingValue.scopeProfile,
        EnvID4AppSettingValue.scopeOpenId,
        EnvID4AppSettingValue.scopeOfflineAccess,
        EnvID4AppSettingValue.scopeRole,
        EnvID4AppSettingValue.scopePhone,
        EnvID4AppSettingValue.scopeIdCard,
        EnvID4AppSettingValue.scopeEmail,
      ],
      Symbols.space,
    );

    var body = <String, String>{
      IdentityAPIConstants.clientIdParamName: EnvID4AppSettingValue.clientId,
      IdentityAPIConstants.clientSecretParamName:
          EnvID4AppSettingValue.clientSeret,
      IdentityAPIConstants.grantTypeParamName:
          EnvID4AppSettingValue.grantTypePassword,
      IdentityAPIConstants.scopeParamName: scopeValue,
      IdentityAPIConstants.usernameParamName: requestModel.username,
      IdentityAPIConstants.passwordParamName: requestModel.password,
    };
    //send request
    var response = await NetworkUtils.postNetworkUrlencoded(
        IdentityAPIConstants.urlConnectToken, {}, body);

    // convert
    // ignore: prefer_typing_uninitialized_variables
    var responseModel;
    if (response.statusCode == NetworkConstants.ok200) {
      responseModel = ConnectToken200ResponseModel.fromJson(
        await NetworkUtils.getMapFromResponse(response),
      );
    } else if (response.statusCode == NetworkConstants.badRequest400) {
      responseModel = ConnectToken400ResponseModel.fromJson(
        await NetworkUtils.getMapFromResponse(response),
      );
    }
    return responseModel;
  }

  @override
  Future<bool> connectRevocation(
      ConnectRevocationRequestModel requestModel) async {
    var header = <String, String>{
      HttpHeaders.authorizationHeader: NetworkUtils.getBasicAuth(),
    };

    //body
    var body = <String, String>{
      IdentityAPIConstants.token: requestModel.token,
      IdentityAPIConstants.tokenTypeHint: requestModel.tokenTypeHint,
    };

    //send request
    var response = await NetworkUtils.postNetworkUrlencoded(
        IdentityAPIConstants.urlConnectRevocation, header, body);

    // convert
    var responseModel = false;
    if (response.statusCode == NetworkConstants.ok200) {
      responseModel = true;
    }
    return responseModel;
  }
}
