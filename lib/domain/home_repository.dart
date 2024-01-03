import 'package:dartz/dartz.dart';
import '../core/failure.dart';
import '../data/model/home_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeModel>> executeHome();
  Future<Either<Failure, HomeModel>> executeGetStateList();
}
