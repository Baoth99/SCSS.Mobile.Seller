import 'dart:io';

import 'package:http/http.dart';
import 'package:seller_app/blocs/models/gender_model.dart';
import 'package:seller_app/blocs/profile_bloc.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:seller_app/log/logger.dart';
import 'package:seller_app/providers/configs/injection_config.dart';
import 'package:seller_app/providers/networks/identity_server_network.dart';
import 'package:seller_app/providers/networks/models/request/connect_revocation_request_model.dart';
import 'package:seller_app/providers/networks/models/request/connect_token_request_model.dart';
import 'package:seller_app/providers/networks/models/request/restore_pass_otp_request_model.dart';
import 'package:seller_app/providers/networks/models/request/update_info_request_model.dart';
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

  Future<bool> updateDeviceId(String deviceId);
  Future<ProfileState?> getProfile();

  Future<int?> updatePassword(
      String id, String oldPassword, String newPassword);

  Future<String> updateImage(File image);
  Future<int?> updateInfo(
    String name,
    String? email,
    Gender gender,
    DateTime? birthdate,
    String? address,
    String? imageUrl,
  );

  Future<bool> restorePassSendingOTP(String phoneNumber);
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

    // revoke access Token
    var fGetStringAccessToken =
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
    }).catchError((error, stackTrace) {
      AppLog.error(error);
    });

    //get refresh Token
    var fGetStringRefreshToken =
        SharedPreferenceUtils.getString(APIKeyConstants.refreshToken)
            .then((value) async {
      if (value != null && value.isNotEmpty) {
        return await _identityServerNetwork.refreshToken(value, client);
      }
    });

    //wait till two of this success
    var getStringAccessToken = await fGetStringAccessToken;

    var responseModle = await fGetStringRefreshToken;

    // should delete in shared Disk

    if (responseModle != null &&
        responseModle.accessToken != null &&
        responseModle.accessToken!.isNotEmpty &&
        responseModle.refreshToken != null &&
        responseModle.refreshToken!.isNotEmpty) {
      var resultAT = SharedPreferenceUtils.setString(
          APIKeyConstants.accessToken, responseModle.accessToken!);

      var resultRT = SharedPreferenceUtils.setString(
          APIKeyConstants.refreshToken, responseModle.refreshToken!);

      return await resultAT && await resultRT;
    }
    return false;
  }

  @override
  Future<bool> updateDeviceId(String deviceId) async {
    Client client = Client();

    bool result = await _identityServerNetwork
        .accountDeviceId(deviceId, client)
        .whenComplete(() => client.close());

    return result;
  }

  @override
  Future<ProfileState?> getProfile() async {
    Client client = Client();
    ProfileState? result;
    var responseModel = await _identityServerNetwork
        .getAccountInfo(client)
        .whenComplete(() => client.close());
    var m = responseModel.resData;
    if (m != null) {
      result = ProfileState(
        id: m.id,
        name: m.name ?? Symbols.empty,
        address: m.address,
        birthDate: m.birthDate == null
            ? null
            : CommonUtils.convertDDMMYYYToDateTime(m.birthDate!),
        email: m.email,
        gender: m.gender == 1 ? Gender.male : Gender.female,
        image: m.image,
        phone: m.phone ?? Symbols.empty,
        totalPoint: m.totalPoint ?? 0,
      );
    }

    return result;
  }

  @override
  Future<int?> updatePassword(
      String id, String oldPassword, String newPassword) async {
    Client client = Client();

    var result = await _identityServerNetwork
        .updatePassword(
          id,
          oldPassword,
          newPassword,
          client,
        )
        .whenComplete(() => client.close());

    return result;
  }

  @override
  Future<String> updateImage(File image) async {
    Client client = Client();
    String imageUrl = Symbols.empty;
    if (image.path.isNotEmpty) {
      var imageBase64 = CommonUtils.convertImageToBasae64(image);

      // call API upload Image
      var imageResponseModel = await _identityServerNetwork.uploadImage(
        imageBase64,
        client,
      );
      if (imageResponseModel.statusCode == NetworkConstants.ok200 &&
          imageResponseModel.isSuccess!) {
        imageUrl = imageResponseModel.resData ?? Symbols.empty;
      } else {
        throw Exception();
      }
    }
    return imageUrl;
  }

  @override
  Future<int?> updateInfo(
    String name,
    String? email,
    Gender gender,
    DateTime? birthdate,
    String? address,
    String? imageUrl,
  ) async {
    Client client = Client();

    email = CommonUtils.assignNullEmpty(email);
    address = CommonUtils.assignNullEmpty(address);
    imageUrl = CommonUtils.assignNullEmpty(imageUrl);

    var result = await _identityServerNetwork
        .updateInfo(
            UpdateInfoRequestModel(
              name: name,
              email: email,
              gender: gender == Gender.male ? 1 : 2,
              birthDate: birthdate,
              address: address,
              imageUrl: imageUrl,
            ),
            client)
        .whenComplete(
          () => client.close(),
        );

    return result;
  }

  @override
  Future<bool> restorePassSendingOTP(String phoneNumber) async {
    phoneNumber = CommonUtils.addZeroBeforePhoneNumber(phoneNumber);

    Client client = Client();
    var result = await _identityServerNetwork
        .restorePassOTP(
          RestorePassOtpRequestModel(phone: phoneNumber),
          client,
        )
        .whenComplete(() => client.close());

    return result.isSuccess! && result.statusCode == NetworkConstants.ok200;
  }
}
