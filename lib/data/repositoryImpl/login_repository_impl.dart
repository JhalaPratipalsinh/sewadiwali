import 'package:dartz/dartz.dart';
import 'package:sewadiwali/core/either_extension_function.dart';

import '../../core/failure.dart';
import '../../core/logger.dart';
import '../../domain/login_repository.dart';
import '../../util/constants.dart';
import '../apiService/base_api_service.dart';
import '../apiService/network_api_service.dart';
import '../model/login_model.dart';
import '../sessionManager/session_manager.dart';

class LoginRepositoryImpl implements LoginRepository {
  final SessionManager sessionManager;
  final BaseAPIService baseAPIService;

  const LoginRepositoryImpl({required this.baseAPIService, required this.sessionManager});

  @override
  Future<Either<Failure, LoginModel>> executeLogin(
      String email, String password, String fcmToken) async {

    final parameter = {
      'email': email,
      'password': password,
      'gcm_id': fcmToken,
    };

    try {
      final possibleData = await baseAPIService.executeAPI(
        loginAPI,
        parameter,
        ApiType.post,
      );

      if (possibleData.isLeft()) {
        return left(Failure(possibleData.getLeft()!.error));
      }
      final response = possibleData.getRight();
      final LoginModel loginDetails = LoginModel.fromJson(response);

      if (loginDetails.status == 1) {
        if (loginDetails.userDetails != null) {
          final data = loginDetails.userDetails;
          await sessionManager.initiateUserLogin(data!);
        }
      } else {
        return left(Failure(loginDetails.message));
      }
      return right(loginDetails);
    } on Exception catch (e) {
      logger.e(e);
      return left(const Failure('Unexpected Error occurred'));
    }
  }

  @override
  Future<Either<Failure, Unit>> logoutUser() {
    // TODO: implement logoutUser
    throw UnimplementedError();
  }

}
