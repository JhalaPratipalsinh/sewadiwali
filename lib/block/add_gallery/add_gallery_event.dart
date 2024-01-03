part of 'add_gallery_bloc.dart';

abstract class AddGalleryEvent extends Equatable {
  const AddGalleryEvent();
}

class AddAddGalleryEvent extends AddGalleryEvent {
  final Map<String,dynamic> queryParameters;
  final List<Map<String,File>> files;
  const AddAddGalleryEvent(this.queryParameters,this.files);

  @override
  List<Object> get props => [queryParameters,files];
}
