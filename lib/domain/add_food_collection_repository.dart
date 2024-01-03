import 'package:dartz/dartz.dart';
import '../core/failure.dart';
import '../data/model/get_center_pantry_list_model.dart';
import '../data/model/success_model.dart';

abstract class AddFoodCollectionRepository {
  Future<Either<Failure, GetCenterPantryListModel>> executeGetCenterPantryList(
      String yearId, String stateId);

  Future<Either<Failure, SuccessModel>> executeAddFoodCollection({
    String collectedFood,
    String stateId,
    String eventName,
    String eventDate,
    String centerId,
    String centerName,
    String remarks,
    String pantryId,}
  );
}
