
import 'package:dartz/dartz.dart';

import '../core/failure.dart';
import '../data/model/success_model.dart';

abstract class ChangePasswordRepository {
  Future<Either<Failure, SuccessModel>> executeChangePassword(
      String userId,
      String oldPassword, String newPassword, String confirmPassword);

      Future<Either<Failure, SuccessModel>> executeForgotPassword(String email,);
}
