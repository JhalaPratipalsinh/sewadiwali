part of 'add_gallery_bloc.dart';

abstract class AddGalleryState extends Equatable {
  const AddGalleryState();

  @override
  List<Object> get props => [];
}

final class AddGalleryInitial extends AddGalleryState {}

class AddGalleryLoadingState extends AddGalleryState {
  const AddGalleryLoadingState();

  @override
  List<Object> get props => [];
}

class AddGallerySuccessState extends AddGalleryState {
  final SuccessModel response;
  const AddGallerySuccessState(this.response);

  @override
  List<Object> get props => [response];
}

class AddGalleryErrorState extends AddGalleryState {
  final String message;
  const AddGalleryErrorState(this.message);

  @override
  List<Object> get props => [message];
}
