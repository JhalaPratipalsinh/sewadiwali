import 'dart:io';

import 'package:dartz/dartz.dart';

import '../core/failure.dart';
import '../data/model/success_model.dart';

abstract class AddGalleryRepository {
  Future<Either<Failure, SuccessModel>> executeAddGalleryCollection(
    Map<String,dynamic> queryParameters,
    List<Map<String,File>> files,
  );
}
