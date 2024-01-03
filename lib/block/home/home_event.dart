part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}


class GetHomeDataEvent extends HomeEvent {
  const GetHomeDataEvent();

  @override
  List<Object> get props => [];
}

class GetStateListEvent extends HomeEvent {
  const GetStateListEvent();

  @override
  List<Object> get props => [];
}
