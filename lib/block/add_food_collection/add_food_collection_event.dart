part of 'add_food_collection_bloc.dart';

abstract class AddFoodCollectionEvent extends Equatable {
  const AddFoodCollectionEvent();
}

class GetCenterAndPantryListEvent extends AddFoodCollectionEvent {
  final String stateId;
  final String yearId;
  const GetCenterAndPantryListEvent(this.stateId, this.yearId);

  @override
  List<Object> get props => [stateId, yearId];
}

class AddAddFoodCollectionEvent extends AddFoodCollectionEvent {
  final String collectedFood;
  final String stateId;
  final String eventName;
  final String eventDate;
  final String centerId;
  final String centerName;
  final String remarks;
  final String pantryId;
  const AddAddFoodCollectionEvent(
    this.collectedFood,
    this.stateId,
    this.eventName,
    this.eventDate,
    this.centerId,
    this.centerName,
    this.remarks,
    this.pantryId,
  );

  @override
  List<Object> get props => [
        collectedFood,
        stateId,
        eventName,
        eventDate,
        centerId,
        centerName,
        remarks,
        pantryId,
      ];
}
