import 'package:dio/dio.dart';

import '../../helper/mangers/constants.dart';

class DioHelper {
  static Dio? _dio;

  static init() {
    BaseOptions baseOptions = BaseOptions(
      baseUrl: "10.0.2.2:5000",
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
      headers: {
        "Content-Type": "application/json",
      },
    );
    _dio = Dio(baseOptions);
  }

  Future<Response> postData({
    required path,
    dynamic data,
    Map<String, dynamic>? query,
  }) async {
    return await _dio!.post(path, queryParameters: query, data: data);
  }
}
