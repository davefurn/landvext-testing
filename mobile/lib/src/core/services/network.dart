import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:landvest/src/core/constants/endpoints.dart';

class NetworkService {
  static final Dio _dio = Dio()
    ..interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  Future<Response?> postRequestHandler(
    String path,
    Map<String, dynamic>? data, {
    Options? options,
  }) async {
    try {
      final a = await _dio.postUri(
        Uri.parse('${AppEndpoints.baseUrl}$path'),
        data: data,
        options: options,
      );

      log(a.data.toString());
      return a;
    } on DioException catch (e) {
      log(e.response.toString());

      return e.response;
    } on SocketException catch (_) {
      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<Response?> putRequestHandler(
    String path,
    Map<String, dynamic> data, {
    Options? options,
  }) async {
    try {
      final a = await _dio.putUri(
        Uri.parse('${AppEndpoints.baseUrl}$path'),
        data: data,
        options: options,
      );
      log(a.data.toString());
      return a;
    } on DioException catch (e) {
      log(e.response.toString());

      return e.response;
    } on SocketException catch (_) {
      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<Response?> getRequestHandler(
    String path, {
    Options? options,
    Map<String, dynamic>? data,
  }) async {
    try {
      final a = await _dio.getUri(
        Uri.parse('${AppEndpoints.baseUrl}$path'),
        data: data,
        options: options,
      );
      log(a.data.toString());
      return a;
    } on DioException catch (e) {
      log(e.response.toString());

      return e.response;
    } on SocketException catch (_) {
      return null;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<Response?> getRequestDifferntUrlHandler(
    String path, {
    Options? options,
    Map<String, dynamic>? data,
  }) async {
    try {
      final a = await _dio.getUri(
        Uri.parse('${AppEndpoints.getAllBanks}$path'),
        data: data,
        options: options,
      );
      log(a.data.toString());
      return a;
    } on DioException catch (e) {
      log(e.response.toString());

      return e.response;
    } on SocketException catch (_) {
      return null;
    } on Exception catch (_) {
      return null;
    }
  }
}
