part of 'gallery_screen_bloc.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object> get props => [];
}

class FetchImagesEvent extends GalleryEvent {}
