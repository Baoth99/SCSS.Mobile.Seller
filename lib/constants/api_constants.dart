import 'package:seller_app/utils/env_util.dart';

class GoongMapAPIConstants {
  //URL
  static const urlPlacesSearchByKeywordURL = '/Place/AutoComplete';
  static const urlReverseGeocoding = '/Geocode';
  static const urlGetPlaceDetailById = '/Place/Detail';

  //Query parameter name
  static const apiKeyParamName = 'api_key';
  static const inputParamName = 'input';
  static const locationParamName = 'location';
  static const latlngParamName = 'latlng';
  static const placeIdParamName = 'place_id';
}

class IdentityAPIConstants {
  //URL
  static final urlConnectToken = '${EnvID4AppSettingValue.apiUrl}connect/token';
  static final urlConnectRevocation =
      '${EnvID4AppSettingValue.apiUrl}connect/revocation';

  //Query parameter name
  static const clientIdParamName = 'client_id';
  static const clientSecretParamName = 'client_secret';
  static const grantTypeParamName = 'grant_type';
  static const scopeParamName = 'scope';
  static const usernameParamName = 'username';
  static const passwordParamName = 'password';
  static const token = 'token';
  static const tokenTypeHint = 'token_type_hint';

  //value
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
}

class APIKeyConstants {
  static const accessToken = 'vechaixanh_seller_access_token';
  static const refreshToken = 'vechaixanh_seller_refresh_token';
}

class APIServiceURI {
  static final collectingRequestRemainingDays =
      '${EnvBaseAppSettingValue.baseApiUrl}collecting-request/remaining-days';
  static final collectingRequestUploadImg =
      '${EnvBaseAppSettingValue.baseApiUrl}collecting-request/upload-img';
  static final collectingRequestRequest =
      '${EnvBaseAppSettingValue.baseApiUrl}collecting-request/request';
}
