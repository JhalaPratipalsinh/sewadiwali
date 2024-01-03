import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/logger.dart';
import '../../../data/model/login_model.dart';
import '../../../domain/login_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc({required this.repository}) : super(const LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(const LoadingState());

      try {
        late final LoginState data;
        if (event is InitiateLoginEvent) {
          final possibleData = await repository.executeLogin(
              event.emailOrPassword, event.password, event.fcmToken);
          data = possibleData.fold(
            (l) => LoginErrorState(l.error),
            (r) => LoadState(r),
          );
        } else if (event is EditProfileEvent) {
         /* final possibleData = await repository.editProfileAPI(event.data);
          data = possibleData.fold(
            (l) => LoginErrorState(l.error),
            (r) => LoadState(r),
          );*/
        }

        emit(data);
      } catch (e) {
        logger.e(e.toString());
        emit(LoginErrorState(e.toString()));
      }
    });
  }
}
