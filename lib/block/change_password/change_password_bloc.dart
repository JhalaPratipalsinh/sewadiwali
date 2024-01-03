import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sewadiwali/data/model/success_model.dart';

import '../../core/logger.dart';
import '../../domain/change_password_repository.dart';

part 'change_password_event.dart';
part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordRepository repository;
  ChangePasswordBloc({required this.repository})
      : super(ChangePasswordInitial()) {
    on<ChangePasswordEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ChangePasswordSubmitEvent>(_onChangePasswordSubmitEvent);
    on<ForgotPasswordSubmitEvent>(_onForgotPasswordSubmitEvent);
  }

  Future<FutureOr<void>> _onChangePasswordSubmitEvent(
      ChangePasswordSubmitEvent event,
      Emitter<ChangePasswordState> emit) async {
    emit(const ChangePasswordLoadingState());
    try {
      final possibleData = await repository.executeChangePassword(event.userId,
          event.oldPassword, event.newPassword, event.confirmPassword);
      emit(possibleData.fold(
        (l) => ChangePasswordErrorState(l.error),
        (r) => ChangePasswordSuccessState(r),
      ));
    } catch (e) {
      logger.e(e.toString());
      emit(ChangePasswordErrorState(e.toString()));
    }
  }

  Future<FutureOr<void>> _onForgotPasswordSubmitEvent(ForgotPasswordSubmitEvent event, Emitter<ChangePasswordState> emit) async {
    emit(const ForgotPasswordLoadingState());
    try {
      final possibleData = await repository.executeForgotPassword(event.email);
      emit(possibleData.fold(
        (l) => ForgotPasswordErrorState(l.error),
        (r) => ForgotPasswordSuccessState(r),
      ));
    } catch (e) {
      logger.e(e.toString());
      emit(ForgotPasswordErrorState(e.toString()));
    }
  }
}
