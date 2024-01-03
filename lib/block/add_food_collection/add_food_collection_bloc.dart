import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../core/logger.dart';
import '../../data/model/get_center_pantry_list_model.dart';
import '../../data/model/success_model.dart';
import '../../domain/add_food_collection_repository.dart';

part 'add_food_collection_event.dart';
part 'add_food_collection_state.dart';

class AddFoodCollectionBloc
    extends Bloc<AddFoodCollectionEvent, AddFoodCollectionState> {
  final AddFoodCollectionRepository repository;

  AddFoodCollectionBloc({required this.repository})
      : super(const AddFoodCollectionInitialState()) {
    on<AddFoodCollectionEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetCenterAndPantryListEvent>(_onGetCenterAndPantryListEvent);
    on<AddAddFoodCollectionEvent>(_onAddAddFoodCollectionEvent);
  }

  Future<FutureOr<void>> _onGetCenterAndPantryListEvent(
      GetCenterAndPantryListEvent event,
      Emitter<AddFoodCollectionState> emit) async {
    emit(const GetCenterAndPatryLoadingState());
    try {
      final possibleData = await repository.executeGetCenterPantryList(
          event.yearId, event.stateId);

      // if (possibleData.isLeft()) {
      //   emit(HomeErrorState(possibleData.getLeft()!.error));
      // } else {
      //   final finalData = possibleData.getRight();
      //   statelist = finalData?.statelist ?? [];
      //   yearlist = finalData?.yearlist ?? [];
      //   emit(HomeSuccessState(possibleData.getRight()!));
      // }

      emit(possibleData.fold(
        (l) => GetCenterAndPatryErrorState(l.error),
        (r) => GetCenterAndPatrySuccessState(r),
      ));
    } catch (e) {
      logger.e(e.toString());
      emit(GetCenterAndPatryErrorState(e.toString()));
    }
  }

  Future<FutureOr<void>> _onAddAddFoodCollectionEvent(
      AddAddFoodCollectionEvent event,
      Emitter<AddFoodCollectionState> emit) async {
    emit(const AddFoodCollectionLoadingState());
    try {
      final possibleData = await repository.executeAddFoodCollection(
        stateId: event.stateId,
        centerId: event.centerId,
        centerName: event.centerName,
        eventName: event.eventName,
        eventDate: event.eventDate,
        collectedFood: event.collectedFood,
        remarks: event.remarks,
        pantryId: event.pantryId,
      );

      // if (possibleData.isLeft()) {
      //   emit(HomeErrorState(possibleData.getLeft()!.error));
      // } else {
      //   final finalData = possibleData.getRight();
      //   statelist = finalData?.statelist ?? [];
      //   yearlist = finalData?.yearlist ?? [];
      //   emit(HomeSuccessState(possibleData.getRight()!));
      // }

      emit(possibleData.fold(
        (l) => AddFoodCollectionErrorState(l.error),
        (r) => AddFoodCollectionSuccessState(r),
      ));
    } catch (e) {
      logger.e(e.toString());
      emit(GetCenterAndPatryErrorState(e.toString()));
    }
  }
}
