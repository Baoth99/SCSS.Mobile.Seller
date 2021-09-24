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

  //Query parameter name
  static const clientIdParamName = 'client_id';
  static const clientSecretParamName = 'client_secret';
  static const grantTypeParamName = 'grant_type';
  static const scopeParamName = 'scope';
  static const usernameParamName = 'username';
  static const passwordParamName = 'password';
}

class APIKeyConstants {
  static const accessToken = 'vechaixanh_seller_access_token';
  static const refreshToken = 'vechaixanh_seller_refresh_token';
}
