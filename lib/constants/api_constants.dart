import 'package:seller_app/utils/env_util.dart';

class GoongMapAPIConstants {
  //URL
  static final urlPlacesSearchByKeywordURL =
      '${EnvMapSettingValue.apiUrl}Place/AutoComplete';
  static final urlReverseGeocoding = '${EnvMapSettingValue.apiUrl}Geocode';
  static final urlGetPlaceDetailById =
      '${EnvMapSettingValue.apiUrl}Place/Detail';

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
  static final feedbackAdmin =
      '${EnvBaseAppSettingValue.baseApiUrl}feedback/feedback-admin/create';
  static final cancelRequest =
      '${EnvBaseAppSettingValue.baseApiUrl}collecting-request/cancel';
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
    moreThanDays: 'Bạn không thể đặt trước quá thời hạn cho phép',
    fromTimeGreaterThanToTime:
        'Thời gian bắt đầu tối thiểu phải lớn hơn thời gian hiện tại 15 phút',
    limitCR: 'Bạn đã đặt tối đa số đơn trong ngày hôm nay',
    lessThan15Minutes: 'Khoảng thời gian phải tối thiểu 15 phút',
    timeRangeNotValid: 'Bạn đã đặt thời gian ngoài giờ hoạt động của chúng tôi',
    coordinate: 'Địa điểm yêu cầu thu gom không hợp lệ',
    invalidDate: 'Ngày đặt lịch yêu cầu thu gom không hợp lí',
    invalidTimeTo: 'Thời gian hẹn kết thúc không hợp lệ',
    invalidTimeFrom: 'Thời gian hẹn bắt đầu không hợp lệ',
    overReceive: 'Đã nhận quá số đơn quy định',
  };

  static const errorSystem = 'Có lỗi đến từ hệ thống';
}
