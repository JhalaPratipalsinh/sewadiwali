part of 'change_password_bloc.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordSubmitEvent extends ChangePasswordEvent {
  final String userId;
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;
  const ChangePasswordSubmitEvent(
      this.userId, this.oldPassword, this.newPassword, this.confirmPassword);

  @override
  List<Object> get props => [userId, oldPassword, newPassword, confirmPassword];
}

class ForgotPasswordSubmitEvent extends ChangePasswordEvent {
  final String email;
  const ForgotPasswordSubmitEvent(
      this.email,);

  @override
  List<Object> get props => [email,];
}
