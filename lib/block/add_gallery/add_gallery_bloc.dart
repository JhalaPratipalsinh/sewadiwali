import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sewadiwali/core/either_extension_function.dart';

import '../../core/logger.dart';
import '../../data/model/success_model.dart';
import '../../domain/add_gallery_repository.dart';

part 'add_gallery_event.dart';
part 'add_gallery_state.dart';

class AddGalleryBloc extends Bloc<AddGalleryEvent, AddGalleryState> {
  final AddGalleryRepository repository;
  AddGalleryBloc({required this.repository}) : super(AddGalleryInitial()) {
    on<AddGalleryEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<AddAddGalleryEvent>(_onAddAddGalleryEvent);

  }

  FutureOr<void> _onAddAddGalleryEvent(AddAddGalleryEvent event, Emitter<AddGalleryState> emit) async {
     emit(const AddGalleryLoadingState());
    try {
      final possibleData = await repository.executeAddGalleryCollection(event.queryParameters,event.files);

      // if (possibleData.isLeft()) {
      //   emit(AddGalleryErrorState(possibleData.getLeft()!.error));
      // } else {
      //   final finalData = possibleData.getRight();
      //   emit(HomeSuccessState(possibleData.getRight()!));
      // }
      emit(possibleData.fold(
        (l) => AddGalleryErrorState(l.error),
        (r) => AddGallerySuccessState(r),
      ));
    } catch (e) {
      logger.e(e.toString());
      emit(AddGalleryErrorState(e.toString()));
    }
  }
}
