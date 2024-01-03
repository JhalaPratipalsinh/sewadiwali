part of 'add_food_collection_bloc.dart';

abstract class AddFoodCollectionState extends Equatable {
  const AddFoodCollectionState();
}

class AddFoodCollectionInitialState extends AddFoodCollectionState {
  const AddFoodCollectionInitialState();

  @override
  List<Object> get props => [];
}

class GetCenterAndPatryLoadingState extends AddFoodCollectionState {
  const GetCenterAndPatryLoadingState();

  @override
  List<Object> get props => [];
}

class GetCenterAndPatrySuccessState extends AddFoodCollectionState {
  final GetCenterPantryListModel response;
  const GetCenterAndPatrySuccessState(this.response);

  @override
  List<Object> get props => [response];
}

class GetCenterAndPatryErrorState extends AddFoodCollectionState {
  final String message;
  const GetCenterAndPatryErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class AddFoodCollectionLoadingState extends AddFoodCollectionState {
  const AddFoodCollectionLoadingState();

  @override
  List<Object> get props => [];
}

class AddFoodCollectionSuccessState extends AddFoodCollectionState {
  final SuccessModel response;
  const AddFoodCollectionSuccessState(this.response);

  @override
  List<Object> get props => [response];
}

class AddFoodCollectionErrorState extends AddFoodCollectionState {
  final String message;
  const AddFoodCollectionErrorState(this.message);

  @override
  List<Object> get props => [message];
}
