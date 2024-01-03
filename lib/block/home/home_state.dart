part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object> get props => [];
}

class HomeLoadingState extends HomeState {
  const HomeLoadingState();

  @override
  List<Object> get props => [];
}

class HomeSuccessState extends HomeState {
  final HomeModel response;
  const HomeSuccessState(this.response);

  @override
  List<Object> get props => [response];
}

class HomeErrorState extends HomeState {
  final String message;
  const HomeErrorState(this.message);

  @override
  List<Object> get props => [message];
}
