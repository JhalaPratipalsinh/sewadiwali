import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../core/failure.dart';
import '../../core/logger.dart';
import '../../injection_container.dart';
import '../sessionManager/session_manager.dart';
import 'base_api_service.dart';

enum ApiType { get, post, put }

class NetworkAPIService implements BaseAPIService {
  final Dio dio;
  final Connectivity connectivity;

  const NetworkAPIService({required this.dio, required this.connectivity});

  @override
  Future<Either<Failure, dynamic>> executeAPI(
      String url, Map<String, dynamic> queryParameters, ApiType apiType) async {
    final connectivityResult = await connectivity.checkConnectivity();
    final loginData = sl<SessionManager>().getUserDetails();
    final String token = loginData?.token ?? "";
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      logger.i('$url Request:  $queryParameters');
      logger.i('token :  $token');
      final Map<String, dynamic> header =
          loginData != null ? {"Authorization": 'Bearer $token'} : {};
      try {
        late Response response;
        if (apiType == ApiType.get) {
          response = queryParameters.isEmpty
              ? await dio.get(
                  url,
                  options: Options(
                    headers: header,
                  ),
                )
              : await dio.get(
                  url,
                  queryParameters: queryParameters,
                  options: Options(
                    headers: header,
                  ),
                );
        } else if (apiType == ApiType.post) {
          response = await dio.post(url,
              data: queryParameters,
              options: Options(
                headers: header,
              ));
        } else {
          response = await dio.put(url,
              data: queryParameters,
              options: Options(
                headers: header,
              ));
        }

        logger.i('$url Response : ${response.data}');

        return right(response.data as Map<String, dynamic>);
      } on DioError catch (e) {
        logger.e(e.message);
        if (e.response!.statusCode == 422 || e.response!.statusCode == 404) {
          return Right(e.response!.data);
        }
        return left(Failure(e.message));
      } on SocketException catch (e) {
        logger.e(e);
        return left(const Failure('Please check the network connection'));
      } on Exception catch (e) {
        logger.e(e);
        return left(const Failure('Unexpected Error occurred'));
      }
    } else {
      return left(const Failure('Please check your internet connection'));
    }
  }

  @override
  Future<Either<Failure, dynamic>> executeFormDataAPI(
      String url, FormData formData, ApiType apiType) async {
    final connectivityResult = await connectivity.checkConnectivity();
    final loginData = sl<SessionManager>().getUserDetails();
    final String token = loginData?.token ?? "";
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      logger.i('$url ');
      logger.i('token :  $token');
      try {
        late Response response;
        response = await dio.post(url,
            data: formData,
            options: Options(
              headers: {"Authorization": 'Bearer $token'},
            ));

        logger.i('$url Response : ${response.data}');

        return right(response.data);
      } on DioError catch (e) {
        logger.e(e.message);
        if (e.response!.statusCode == 422 || e.response!.statusCode == 404) {
          return Right(e.response!.data);
        }
        return left(Failure(e.message));
      } on SocketException catch (e) {
        logger.e(e);
        return left(const Failure('Please check the network connection'));
      } on Exception catch (e) {
        logger.e(e);
        return left(const Failure('Unexpected Error occurred'));
      }
    } else {
      return left(const Failure('Please check your internet connection'));
    }
  }
}
