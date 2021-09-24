abstract class ConnectTokenResponseModel {}

class ConnectToken200ResponseModel implements ConnectTokenResponseModel {
  ConnectToken200ResponseModel({
    this.accessToken,
    this.expiresIn,
    this.tokenType,
    this.refreshToken,
    this.scope,
  });

  final String? accessToken;
  final int? expiresIn;
  final String? tokenType;
  final String? refreshToken;
  final String? scope;

  factory ConnectToken200ResponseModel.fromJson(Map<String, dynamic> json) =>
      ConnectToken200ResponseModel(
        accessToken: json["access_token"],
        expiresIn: json["expires_in"],
        tokenType: json["token_type"],
        refreshToken: json["refresh_token"],
        scope: json["scope"],
      );
}

class ConnectToken400ResponseModel implements ConnectTokenResponseModel {
  ConnectToken400ResponseModel({
    this.error,
    this.errorDescription,
  });

  final String? error;
  final String? errorDescription;

  factory ConnectToken400ResponseModel.fromJson(Map<String, dynamic> json) =>
      ConnectToken400ResponseModel(
        error: json["error"],
        errorDescription: json["error_description"],
      );
}
