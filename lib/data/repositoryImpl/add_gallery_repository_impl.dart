import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:sewadiwali/core/either_extension_function.dart';

import '../../core/failure.dart';
import '../../core/logger.dart';
import '../../domain/add_gallery_repository.dart';
import '../../util/constants.dart';
import '../apiService/base_api_service.dart';
import '../apiService/network_api_service.dart';
import '../model/success_model.dart';

class AddGalleryRepositoryImpl implements AddGalleryRepository {
  final BaseAPIService baseAPIService;

  const AddGalleryRepositoryImpl({
    required this.baseAPIService,
  });

  @override
  Future<Either<Failure, SuccessModel>> executeAddGalleryCollection(
    Map<String, dynamic> queryParameters,
    List<Map<String, File>> files,
  ) async {
    FormData formData = FormData();
    queryParameters.forEach((key, value) {
      formData.fields.add(MapEntry(key, value.toString()));
    });

    for (int i = 0; i < files.length; i++) {
      Map<String, File> fileMap = files[i];

      fileMap.forEach((key, file) {
        formData.files.add(MapEntry(
          key,
          MultipartFile.fromFileSync(file.path, filename: "image$i.jpeg"),
        ));
      });
    }
    try {
      final possibleData = await baseAPIService.executeFormDataAPI(
          addGalleryAPI, formData, ApiType.post);

      if (possibleData.isLeft()) {
        return left(Failure(possibleData.getLeft()!.error));
      }
      final Map<String, dynamic> response =
          possibleData.getRight() as Map<String, dynamic>;
      final SuccessModel finalResponse = SuccessModel.fromJson(response);

      return finalResponse.status == 1
          ? right(finalResponse)
          : left(Failure(finalResponse.message));
    } on Exception catch (e) {
      logger.e(e);
      return left(const Failure('Unexpected Error occurred'));
    }
  }
}
