import 'package:dartz/dartz.dart';
import '../core/failure.dart';
import '../data/model/login_model.dart';


abstract class LoginRepository {
  Future<Either<Failure, LoginModel>> executeLogin(
      String email, String password, String fcmToken);

  Future<Either<Failure, Unit>> logoutUser();

}
