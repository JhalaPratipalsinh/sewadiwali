import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/failure.dart';
import 'network_api_service.dart';

abstract class BaseAPIService {
  Future<Either<Failure, dynamic>> executeAPI(
      String url, Map<String, dynamic> queryParameters, ApiType apiType);

      Future<Either<Failure, dynamic>> executeFormDataAPI(
      String url, FormData formData, ApiType apiType);
}
