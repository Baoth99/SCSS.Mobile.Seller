import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:seller_app/constants/api_constants.dart';
import 'package:seller_app/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:seller_app/exceptions/custom_exceptions.dart';
import 'package:seller_app/providers/networks/models/response/base_response_model.dart';
import 'package:seller_app/utils/env_util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class CommonUtils {
  static DateTime? convertDDMMYYYToDateTime(String date) {
    DateTime? result;
    try {
      DateFormat format = DateFormat("dd-MM-yyyy");
      result = format.parse(date);
    } catch (e) {}
    return result;
  }

  static List<int> convertImageToBasae64(File file) {
    return file.readAsBytesSync().toList();
  }

  static String convertTimeToString(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour}:${timeOfDay.minute}';
  }

  static String toStringPadleft(int number, int width) {
    return number.toString().padLeft(width, '0');
  }

  static String concatString(List<String> strs,
      [String seperator = Symbols.space]) {
    return strs.join(seperator);
  }

  static DateTime getNearDateTime(int minuteInterval, [DateTime? now]) {
    now ??= DateTime.now();
    var nowMinute = now.minute;
    var dividedNumber = nowMinute ~/ minuteInterval;

    var minuteAdded = dividedNumber * minuteInterval + minuteInterval * 2;

    final result = DateTime(now.year, now.month, now.day, now.hour, 0).add(
      Duration(minutes: minuteAdded),
    );
    return result;
  }

  static TimeOfDay getNearMinute(int minuteInterval) {
    return TimeOfDay.fromDateTime(getNearDateTime(minuteInterval));
  }

  static int compareTwoTimeOfDays(TimeOfDay time1, TimeOfDay time2) {
    return convertTimeOfDayToDouble(time1).compareTo(
      convertTimeOfDayToDouble(time2),
    );
  }

  static double convertTimeOfDayToDouble(TimeOfDay time) {
    return time.hour + time.minute / TimeOfDay.minutesPerHour;
  }

  static String combineDateToTime(
      DateTime date, String fromtime, String totime) {
    String strDate = convertDateTimeToVietnamese(date);
    return '$strDate${Symbols.comma} $fromtime ${Symbols.minus} $totime';
  }

  static double differenceTwoTimeOfDay(TimeOfDay time1, TimeOfDay time2) {
    double timeNum1 = convertTimeOfDayToDouble(time1);
    double timeNum2 = convertTimeOfDayToDouble(time2);
    return (timeNum2 - timeNum1).abs() * TimeOfDay.minutesPerHour;
  }

  static String convertDateTimeToVietnamese(DateTime? date) {
    if (date == null) return Symbols.empty;

    //today
    final now = DateTime.now();

    // today and tomorrow
    if (now.year == date.year && now.month == date.month) {
      if (now.day == date.day) {
        return VietnameseDate.today;
      } else if (date.day - now.day == 1) {
        return VietnameseDate.tomorrow;
      }
    }

    var weekday = VietnameseDate.weekdayMap[date.weekday];
    var result = VietnameseDate.pattern
        .replaceFirst(VietnameseDate.weekdayParam, weekday ?? Symbols.empty)
        .replaceFirst(VietnameseDate.dayParam, date.day.toString())
        .replaceFirst(VietnameseDate.monthParam, date.month.toString());
    return result;
  }

  static TimeOfDay addTimeOfDay(TimeOfDay time, int minute) {
    double doubleTime = time.hour + time.minute / 60 + minute / 60;
    int h = doubleTime.truncate();
    int m = ((doubleTime - doubleTime.truncate()) * 60).toInt();

    return TimeOfDay(hour: h, minute: m);
  }

  static String convertToBase64(String str) {
    return base64Encode(utf8.encode(str));
  }
}

class NetworkUtils {
  static String getUrlWithQueryString(String uri, Map<String, String> queries) {
    // ignore: non_constant_identifier_names
    var URI = Uri.parse(uri);
    URI = URI.replace(queryParameters: queries);
    return URI.toString();
  }

  static Future<T>
      checkSuccessStatusCodeAPIMainResponseModel<T extends BaseResponseModel>(
    http.Response response,
    T Function(String) convertJson,
  ) async {
    var responseModel = await NetworkUtils.getModelOfResponseMainAPI<T>(
      response,
      convertJson,
    );

    if (responseModel.statusCode == NetworkConstants.ok200 &&
        responseModel.isSuccess != null &&
        responseModel.isSuccess!) return responseModel;

    //
    throw Exception();
  }

  static Future<Map<String, dynamic>> getMapFromResponse(
      http.Response response) async {
    return jsonDecode(response.body);
  }

  static Future<http.Response> getNetwork({
    required String uri,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
    required http.Client client,
  }) async {
    var url = Uri.parse(uri).replace(
      queryParameters: queries,
    );

    //create request
    var response = await client.get(
      url,
      headers: headers,
    );

    //add header

    return response;
  }

  static Future<http.Response> getNetworkWithBearer({
    required String uri,
    Map<String, String>? headers,
    Map<String, dynamic>? queries,
    required http.Client client,
  }) async {
    var newHeaders = <String, String>{
      HttpHeaders.authorizationHeader: await getBearerToken(),
    }..addAll(headers ?? {});

    return await getNetwork(
      uri: uri,
      headers: newHeaders,
      client: client,
      queries: queries,
    );
  }

  static Future<String> getBearerToken() async {
    String accessToken =
        await SharedPreferenceUtils.getString(APIKeyConstants.accessToken) ??
            Symbols.empty;
    accessToken = NetworkConstants.bearerPattern
        .replaceFirst(NetworkConstants.data, accessToken);

    return accessToken;
  }

  static String getBasicAuth() {
    return NetworkConstants.basicAuth.replaceFirst(
      NetworkConstants.data,
      CommonUtils.convertToBase64(
          '${EnvID4AppSettingValue.clientId}:${EnvID4AppSettingValue.clientSeret}'),
    );
  }

  static Future<http.Response> postMultipart(
    String uri,
    Map<String, String> headers,
    http.MultipartFile multipartFile,
    http.Client client,
  ) async {
    var header = {
      HttpHeaders.authorizationHeader: await getBearerToken(),
    }..addAll(headers);

    var request = http.MultipartRequest(
      NetworkConstants.postType,
      Uri.parse(uri),
    );
    request.files.add(multipartFile);
    request.headers.addAll(header);
    http.StreamedResponse response = await client.send(request);
    var result = await http.Response.fromStream(response);
    return result;
  }

  static Future<http.Response> postBodyWithBearerAuth({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    required http.Client client,
  }) async {
    var mainHeader = <String, String>{
      HttpHeaders.authorizationHeader: await getBearerToken(),
    };

    if (headers != null) {
      mainHeader.addAll(headers);
    }

    return await postBody(
      uri: uri,
      headers: mainHeader,
      body: body,
      client: client,
    );
  }

  static Future<http.Response> postBody({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    required http.Client client,
  }) async {
    var response = client.post(
      Uri.parse(
        uri,
      ),
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> putBody({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    required http.Client client,
  }) async {
    var response = client.put(
      Uri.parse(
        uri,
      ),
      body: body,
      headers: headers,
    );
    return response;
  }

  static Future<http.Response> putBodyWithBearerAuth({
    required String uri,
    Map<String, String>? headers,
    Object? body,
    required http.Client client,
  }) async {
    var mainHeader = <String, String>{
      HttpHeaders.authorizationHeader: await getBearerToken(),
    };

    if (headers != null) {
      mainHeader.addAll(headers);
    }

    return await putBody(
      uri: uri,
      headers: mainHeader,
      body: body,
      client: client,
    );
  }

  // static Future<Map<String, dynamic>> getMapOfStreamResponse(
  //     http.Response response) async {
  //   switch (response.statusCode) {
  //     case NetworkConstants.ok200:
  //       var responseMap = await NetworkUtils.getMapFromResponse(response);
  //       //get statusCode
  //       var statusCode = responseMap[NetworkConstants.statusCode];
  //       var isSucess = responseMap[NetworkConstants.isSuccess];
  //       if (statusCode is int &&
  //           statusCode == NetworkConstants.ok200 &&
  //           isSucess) {
  //         return responseMap;
  //       }
  //       throw Exception();
  //     case NetworkConstants.unauthorized401:
  //       throw UnauthorizedException();
  //     default:
  //       throw Exception();
  //   }
  // }

  static Future<T> getModelOfResponseMainAPI<T>(
      http.Response response, T Function(String) convert) async {
    switch (response.statusCode) {
      case NetworkConstants.ok200:
        T model = convert(response.body);
        return model;
      case NetworkConstants.unauthorized401:
        throw UnauthorizedException();
      default:
        throw Exception();
    }
  }
}

class CommonTest {
  static Future<void> delay() async {
    return await Future<void>.delayed(
      const Duration(
        seconds: 2,
      ),
    );
  }
}

class SharedPreferenceUtils {
  static Future<bool> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();

    return await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }
}
