part of 'change_password_bloc.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();
}

final class ChangePasswordInitial extends ChangePasswordState {

  @override
  List<Object> get props => [];
}


class ChangePasswordLoadingState extends ChangePasswordState {
  const ChangePasswordLoadingState();

  @override
  List<Object> get props => [];
}

class ChangePasswordSuccessState extends ChangePasswordState {
  final SuccessModel response;
  const ChangePasswordSuccessState(this.response);

  @override
  List<Object> get props => [response];
}

class ChangePasswordErrorState extends ChangePasswordState {
  final String message;
  const ChangePasswordErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class ForgotPasswordLoadingState extends ChangePasswordState {
  const ForgotPasswordLoadingState();

  @override
  List<Object> get props => [];
}

class ForgotPasswordSuccessState extends ChangePasswordState {
  final SuccessModel response;
  const ForgotPasswordSuccessState(this.response);

  @override
  List<Object> get props => [response];
}

class ForgotPasswordErrorState extends ChangePasswordState {
  final String message;
  const ForgotPasswordErrorState(this.message);

  @override
  List<Object> get props => [message];
}
