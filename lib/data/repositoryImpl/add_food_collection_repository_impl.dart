import 'package:sewadiwali/core/either_extension_function.dart';
import 'package:dartz/dartz.dart';
import '../../core/failure.dart';
import '../../core/logger.dart';
import '../../domain/add_food_collection_repository.dart';
import '../../injection_container.dart';
import '../../util/constants.dart';
import '../apiService/base_api_service.dart';
import '../apiService/network_api_service.dart';
import '../model/get_center_pantry_list_model.dart';
import '../model/success_model.dart';
import '../sessionManager/session_manager.dart';

class AddFoodCollectionRepositoryImpl implements AddFoodCollectionRepository {
  final BaseAPIService baseAPIService;

  const AddFoodCollectionRepositoryImpl({
    required this.baseAPIService,
  });

  @override
  Future<Either<Failure, GetCenterPantryListModel>> executeGetCenterPantryList(
      String strYear, String stateId) async {
    try {
      final possibleData = await baseAPIService.executeAPI(
        getCenterAndPantryAPI,
        {'year': strYear, 'state_id': stateId},
        ApiType.post,
      );

      if (possibleData.isLeft()) {
        return left(Failure(possibleData.getLeft()!.error));
      }
      final response = possibleData.getRight();
      final GetCenterPantryListModel getCenterPantryListData =
          GetCenterPantryListModel.fromJson(response);

      return getCenterPantryListData.status == 1
          ? right(getCenterPantryListData)
          : left(Failure(getCenterPantryListData.message));
    } on Exception catch (e) {
      logger.e(e);
      return left(const Failure('Unexpected Error occurred'));
    }
  }

  @override
  Future<Either<Failure, SuccessModel>> executeAddFoodCollection(
    {String collectedFood = "",
    String stateId = "",
    String eventName = "",
    String eventDate = "",
    String centerId = "",
    String centerName = "",
    String remarks = "",
    String pantryId = "",
    }
  ) async {
    try {
      final loginData = sl<SessionManager>().getUserDetails();
      final possibleData = await baseAPIService.executeAPI(
        addFoodCollectionAPI,
        {
          "collected_food": collectedFood,
          "state_id": stateId,
          "event_name": eventName,
          "event_date": eventDate,
          "center_id": centerId,
          "center_name": centerName,
          "remarks": remarks,
          "pantry_id": pantryId,
          "user_id": loginData?.id,
          "usertype": loginData?.useType,
        },
        ApiType.post,
      );

      if (possibleData.isLeft()) {
        return left(Failure(possibleData.getLeft()!.error));
      }
      final response = possibleData.getRight();
      final SuccessModel finalResponse =
          SuccessModel.fromJson(response);

      return finalResponse.status == 1
          ? right(finalResponse)
          : left(Failure(finalResponse.message));
    } on Exception catch (e) {
      logger.e(e);
      return left(const Failure('Unexpected Error occurred'));
    }
  }
}
