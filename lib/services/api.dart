import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../utils/app_exception.dart';

// TODO: move to config
const String baseApiUrl = 'dog.ceo';

class ApiService {
  ApiService._internal();

  static final ApiService _apiService = ApiService._internal();
  static final _client = http.Client();

  bool _logEnabled = true;

  final Map<String, String> _headers = {
    HttpHeaders.contentTypeHeader: 'application/json',
    HttpHeaders.acceptHeader: 'application/json',
  };

  http.Client get client => _client;

  set logEnabled(bool value) {
    _logEnabled = value;
  }

  factory ApiService() {
    return _apiService;
  }

  Future<ApiResponse> _onError(error) async {
    // developer.log('onError:', name: 'api', error: error);
    if (_logEnabled) print('_onError: -> ');
    if (_logEnabled) print(error);
    if (error is AppException) {
      return Future.error(ApiResponse.error(error, 1));
    }

    // TODO: Handle DioError here
    // ...
    return Future.error(error);
  }

  Future<ApiResponse> _onResponse(
    http.Response response,
  ) {
    if (_logEnabled) print('_onResponse: -> ');
    if (_logEnabled) print(response);
    if (_logEnabled) print(response.statusCode);
    if (_logEnabled) print(response.body);

    switch (response.statusCode) {
      case 200:
        if (response.body.isNotEmpty) {
          // When paxsky api success
          final jsonResponse =
              jsonDecode(response.body) as Map<String, dynamic>;
          if (jsonResponse['status'] == "success") {
            // continue with succes
            return Future.value(
              ApiResponse.success(
                jsonResponse,
              ),
            );
          }

          //  When own api return error object
          if (jsonResponse['error'] != null) {
            // continue error code
            return Future.value(
              ApiResponse.error(
                jsonResponse['error'],
                jsonResponse['error']['code'],
              ),
            );
          }
        }
        // others: external endpoints
        return Future.value(ApiResponse.success(response));

      case 400:
        return _onError(
          BadRequestException(response.body.toString()),
        );
      case 401:
      case 403:
        return _onError(
          UnauthorisedException(response.body.toString()),
        );
      case 500:
      default:
        return _onError(FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}'));
    }
  }

  Future<ApiResponse> get(String route, {Map<String, dynamic>? params}) async {
    try {
      if (_logEnabled) print(params);

      final response = await _client.get(
        Uri.https(baseApiUrl, route, params),
        headers: _headers,
      );

      // Do somthing and return
      return _onResponse(response);
    } catch (e) {
      return _onError(FetchDataException(e.toString()));
    }
  }

  Future<ApiResponse> post(String route, {Map<String, dynamic>? params}) async {
    try {
      final response = await _client.post(
        Uri.https(baseApiUrl, route),
        body: params,
        headers: _headers,
      );

      // Do somthing and return
      return _onResponse(response);
    } catch (e) {
      return _onError(FetchDataException(e.toString()));
    }
  }
}

enum ApiStatus { success, error }

class ApiResponse {
  ApiResponse.success(this.data) : status = ApiStatus.success;
  ApiResponse.error(this.error, this.errorCode) : status = ApiStatus.error;

  ApiStatus status;
  dynamic data; // response.data.success or response.data
  dynamic error; // response.data.error
  int? errorCode; // response.data.error.code

  @override
  String toString() {
    return 'Status : $status \n errorCode : $errorCode \n Data : $data \n Error : $error';
  }
}
