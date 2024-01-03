import 'package:dartz/dartz.dart';
import 'package:sewadiwali/core/either_extension_function.dart';

import '../../core/failure.dart';
import '../../core/logger.dart';
import '../../domain/change_password_repository.dart';
import '../../injection_container.dart';
import '../../util/constants.dart';
import '../apiService/base_api_service.dart';
import '../apiService/network_api_service.dart';
import '../model/success_model.dart';
import '../sessionManager/session_manager.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final BaseAPIService baseAPIService;

  const ChangePasswordRepositoryImpl({
    required this.baseAPIService,
  });

  @override
  Future<Either<Failure, SuccessModel>> executeChangePassword(String userId,
      String oldPassword, String newPassword, String confirmPassword) async {
    final loginData = sl<SessionManager>().getUserDetails();
    final parameter = {
      "user_id": userId,
      "old_password": oldPassword,
      "new_password1": newPassword,
      "new_password2": confirmPassword,
      "usertype": loginData?.useType,
    };

    try {
      final possibleData = await baseAPIService.executeAPI(
        changePasswordAPI,
        parameter,
        ApiType.post,
      );

      if (possibleData.isLeft()) {
        return left(Failure(possibleData.getLeft()!.error));
      }
      final response = possibleData.getRight();
      final SuccessModel finalResponse = SuccessModel.fromJson(response);

      if (finalResponse.status == 1) {
        return right(finalResponse);
      } else {
        return left(Failure(finalResponse.message));
      }
    } on Exception catch (e) {
      logger.e(e);
      return left(const Failure('Unexpected Error occurred'));
    }
  }

  @override
  Future<Either<Failure, SuccessModel>> executeForgotPassword(
    String email,
  ) async {
    // final loginData = sl<SessionManager>().getUserDetails();
    final parameter = {
      "email": email,
      // "usertype": loginData?.useType,
    };

    try {
      final possibleData = await baseAPIService.executeAPI(
        forgotPasswordAPI,
        parameter,
        ApiType.post,
      );

      if (possibleData.isLeft()) {
        return left(Failure(possibleData.getLeft()!.error));
      }
      final response = possibleData.getRight();
      final SuccessModel finalResponse = SuccessModel.fromJson(response);

      if (finalResponse.status == 1) {
        return right(finalResponse);
      } else {
        return left(Failure(finalResponse.message));
      }
    } on Exception catch (e) {
      logger.e(e);
      return left(const Failure('Unexpected Error occurred'));
    }
  }
}
