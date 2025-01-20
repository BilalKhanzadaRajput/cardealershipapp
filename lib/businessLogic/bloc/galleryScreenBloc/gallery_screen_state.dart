part of 'gallery_screen_bloc.dart';

class GalleryState extends Equatable {
  final bool isLoading;
  final List<String> imageUrls;
  final bool hasError;

  const GalleryState({
    required this.isLoading,
    required this.imageUrls,
    required this.hasError,
  });

  @override
  List<Object> get props => [isLoading, imageUrls, hasError];

  GalleryState copyWith({
    bool? isLoading,
    List<String>? imageUrls,
    bool? hasError,
  }) {
    return GalleryState(
      isLoading: isLoading ?? this.isLoading,
      imageUrls: imageUrls ?? this.imageUrls,
      hasError: hasError ?? this.hasError,
    );
  }
}
