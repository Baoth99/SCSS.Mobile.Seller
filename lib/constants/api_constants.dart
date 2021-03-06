import 'package:seller_app/utils/env_util.dart';

class GoongMapAPIConstants {
  //URL
  static final urlPlacesSearchByKeywordURL =
      '${EnvBaseAppSettingValue.baseApiUrl}map/place/autocomplete';
  static final urlReverseGeocoding =
      '${EnvBaseAppSettingValue.baseApiUrl}map/geocode';
  static final urlGetPlaceDetailById =
      '${EnvBaseAppSettingValue.baseApiUrl}map/place/detail';

  //Query parameter name
  static const apiKeyParamName = 'api_key';
  static const inputParamName = 'input';
  static const locationParamName = 'location';
  static const latlngParamName = 'latlng';
  static const placeIdParamName = 'place_id';
}

class IdentityAPIConstants {
  //URLz
  static final urlConnectToken = '${EnvID4AppSettingValue.apiUrl}connect/token';
  static final urlConnectRevocation =
      '${EnvID4AppSettingValue.apiUrl}connect/revocation';
  static final urlChangePassword =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/change-password';

  static final accountSendOTP =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/send-otp';

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
  static final activityGet = '${EnvBaseAppSettingValue.baseApiUrl}activity/get';
  static final activityDetail =
      '${EnvBaseAppSettingValue.baseApiUrl}activity/detail';
  static final imageGet = '${EnvBaseAppSettingValue.baseApiUrl}image/get';
  static final accountDeviceID =
      '${EnvBaseAppSettingValue.baseApiUrl}seller/account/device-id';
  static final accountSellerInfo =
      '${EnvBaseAppSettingValue.baseApiUrl}seller/account/seller-info';

  static final accountUploadImage =
      '${EnvBaseAppSettingValue.baseApiUrl}seller/account/upload-image';
  static final accountUpdate =
      '${EnvBaseAppSettingValue.baseApiUrl}seller/account/update';
  static final requestAbility =
      '${EnvBaseAppSettingValue.baseApiUrl}collecting-request/request-ability';
  static final operatingTime =
      '${EnvBaseAppSettingValue.baseApiUrl}collecting-request/operating-time';
  static final notificationGet =
      '${EnvBaseAppSettingValue.baseApiUrl}notification/get';
  static final notificationUnreadCount =
      '${EnvBaseAppSettingValue.baseApiUrl}notification/unread-count';
  static final notificationRead =
      '${EnvBaseAppSettingValue.baseApiUrl}notification/read';
  static final createComplaint =
      '${EnvBaseAppSettingValue.baseApiUrl}seller-complaint/create';
  static final cancelRequest =
      '${EnvBaseAppSettingValue.baseApiUrl}collecting-request/cancel';
  static final feedbackTransaction =
      '${EnvBaseAppSettingValue.baseApiUrl}feedback/trans-feedback/create';
  static final nearestApprovedRequest =
      '${EnvBaseAppSettingValue.baseApiUrl}dashboard/nearest-approved-request';
  static final restorePassOTP =
      '${EnvBaseAppSettingValue.baseApiUrl}seller/account/restore-pass-otp';
  static final confirmRestorePassOTP =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/confirm-otp';
  static final restorePassword =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/restore-password';
  static final registerOTP =
      '${EnvBaseAppSettingValue.baseApiUrl}seller/account/register-otp';
  static final confirmOTPRegister =
      '${EnvID4AppSettingValue.apiUrl}api/identity/account/confirm-otp-register';
  static final register =
      '${EnvBaseAppSettingValue.baseApiUrl}seller/account/register';
  static final getPersonalLocation =
      '${EnvBaseAppSettingValue.baseApiUrl}personal-location/get';
  static final removePersonalLocation =
      '${EnvBaseAppSettingValue.baseApiUrl}personal-location/remove';
  static final addPersonalLocation =
      '${EnvBaseAppSettingValue.baseApiUrl}personal-location/add';
}

class InvalidRequestCode {
  static const moreThanDays = "MTDS001";
  static const fromTimeGreaterThanToTime = "FTGTTT";
  static const limitCR = "LIMITCR001";
  static const lessThan15Minutes = "LT15MS";
  static const timeRangeNotValid = "TRNVD001";
  static const coordinate = "IVCDN001";
  static const invalidDate = "IVDATE0001";
  static const invalidTimeTo = "IVTIMETO0001";
  static const invalidTimeFrom = "IVTIMEFRO0001";
  static const overReceive = "OCR0001";

  static const List<String> invalidRequestCodes = [
    moreThanDays,
    fromTimeGreaterThanToTime,
    limitCR,
    lessThan15Minutes,
    timeRangeNotValid,
    coordinate,
    invalidDate,
    invalidTimeTo,
    invalidTimeFrom,
    overReceive,
  ];

  static const Map<String, String> invalidRequestCodeMap = {
    moreThanDays: 'B???n kh??ng th??? ?????t tr?????c qu?? th???i h???n cho ph??p',
    fromTimeGreaterThanToTime:
        'Th???i gian b???t ?????u t???i thi???u ph???i l???n h??n th???i gian hi???n t???i 15 ph??t',
    limitCR: 'B???n ???? ?????t t???i ??a s??? ????n trong ng??y h??m nay',
    lessThan15Minutes: 'Kho???ng th???i gian ph???i t???i thi???u 15 ph??t',
    timeRangeNotValid: 'B???n ???? ?????t th???i gian ngo??i gi??? ho???t ?????ng c???a ch??ng t??i',
    coordinate: '?????a ??i???m y??u c???u thu gom kh??ng h???p l???',
    invalidDate: 'Ng??y ?????t l???ch y??u c???u thu gom kh??ng h???p l??',
    invalidTimeTo: 'Th???i gian h???n k???t th??c kh??ng h???p l???',
    invalidTimeFrom: 'Th???i gian h???n b???t ?????u kh??ng h???p l???',
    overReceive: '???? nh???n qu?? s??? ????n quy ?????nh',
  };

  static const errorSystem = 'C?? l???i ?????n t??? h??? th???ng';
}
