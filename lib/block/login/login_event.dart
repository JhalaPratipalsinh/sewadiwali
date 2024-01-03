part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class InitiateLoginEvent extends LoginEvent {
  final String emailOrPassword;
  final String password;
  final String fcmToken;

  const InitiateLoginEvent(this.emailOrPassword, this.password, this.fcmToken);

  @override
  List<Object> get props => [emailOrPassword, password, fcmToken];
}

class EditProfileEvent extends LoginEvent {
  final Map<String, dynamic> data;

  const EditProfileEvent({required this.data});

  @override
  List<Object> get props => [data];
}
