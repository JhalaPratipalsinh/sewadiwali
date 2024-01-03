import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sewadiwali/core/either_extension_function.dart';

import '../../core/logger.dart';
import '../../data/model/home_model.dart';
import '../../domain/home_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;
  List<Statelist> statelist = [];
  List<Yearlist> yearlist = [];

  HomeBloc({required this.repository}) : super(const HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetHomeDataEvent>(_onGetHomeDataEvent);
    on<GetStateListEvent>(_onGetStateListEvent);
  }

  Future<FutureOr<void>> _onGetHomeDataEvent(
      GetHomeDataEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoadingState());
    try {
      final possibleData = await repository.executeHome();

      if (possibleData.isLeft()) {
        emit(HomeErrorState(possibleData.getLeft()!.error));
      } else {
        final finalData = possibleData.getRight();
        statelist = finalData?.statelist ?? [];
        yearlist = finalData?.yearlist ?? [];
        emit(HomeSuccessState(possibleData.getRight()!));
      }
      // emit(possibleData.fold(
      //   (l) => HomeErrorState(l.error),
      //   (r) => HomeSuccessState(r),
      // ));
    } catch (e) {
      logger.e(e.toString());
      emit(HomeErrorState(e.toString()));
    }
  }


  Future<FutureOr<void>> _onGetStateListEvent(GetStateListEvent event, Emitter<HomeState> emit) async {
    emit(const HomeLoadingState());
    try {
      final possibleData = await repository.executeGetStateList();

      if (possibleData.isLeft()) {
        emit(HomeErrorState(possibleData.getLeft()!.error));
      } else {
        final finalData = possibleData.getRight();
        statelist = finalData?.statelist ?? [];
        emit(HomeSuccessState(possibleData.getRight()!));
      }
    } catch (e) {
      logger.e(e.toString());
      emit(HomeErrorState(e.toString()));
    }
  }
}
