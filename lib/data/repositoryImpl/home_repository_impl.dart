import 'package:sewadiwali/core/either_extension_function.dart';
import 'package:dartz/dartz.dart';

import '../../core/failure.dart';
import '../../core/logger.dart';
import '../../domain/home_repository.dart';
import '../../injection_container.dart';
import '../../util/constants.dart';
import '../apiService/base_api_service.dart';
import '../apiService/network_api_service.dart';
import '../model/home_model.dart';
import '../sessionManager/session_manager.dart';

class HomeRepositoryImpl implements HomeRepository {
  final BaseAPIService baseAPIService;

  const HomeRepositoryImpl({
    required this.baseAPIService,
  });

  @override
  Future<Either<Failure, HomeModel>> executeHome() async {
    try {
      final loginData = sl<SessionManager>().getUserDetails();
      final possibleData = await baseAPIService.executeAPI(
        "$homeAPI?usertype=${loginData?.useType}",
        {},
        ApiType.get,
      );

      if (possibleData.isLeft()) {
        return left(Failure(possibleData.getLeft()!.error));
      }
      final response = possibleData.getRight();
      final HomeModel homedata = HomeModel.fromJson(response);

      return homedata.status == 1
          ? right(homedata)
          : left(Failure(homedata.message));
    } on Exception catch (e) {
      logger.e(e);
      return left(const Failure('Unexpected Error occurred'));
    }
  }

  @override
  Future<Either<Failure, HomeModel>> executeGetStateList() async {
    try {
      final possibleData = await baseAPIService.executeAPI(
        stateListAPI,
        {},
        ApiType.get,
      );

      if (possibleData.isLeft()) {
        return left(Failure(possibleData.getLeft()!.error));
      }
      final response = possibleData.getRight();
      final HomeModel homedata = HomeModel.fromJson(response);

      return homedata.status == 1
          ? right(homedata)
          : left(Failure(homedata.message));
    } on Exception catch (e) {
      logger.e(e);
      return left(const Failure('Unexpected Error occurred'));
    }
  }
}
