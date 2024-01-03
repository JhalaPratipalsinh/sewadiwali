part of 'login_bloc.dart';

abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();

  @override
  List<Object> get props => [];
}

class LoadingState extends LoginState {
  const LoadingState();

  @override
  List<Object> get props => [];
}

class LoadState extends LoginState {
  final LoginModel loginModel;

  const LoadState(this.loginModel);

  @override
  List<Object> get props => [loginModel];
}

class LoginErrorState extends LoginState {
  final String error;

  const LoginErrorState(this.error);

  @override
  List<Object> get props => [error];
}
