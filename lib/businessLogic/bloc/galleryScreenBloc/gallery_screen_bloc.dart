import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';

part 'gallery_screen_event.dart';

part 'gallery_screen_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final FirebaseStorage firebaseStorage;

  GalleryBloc({required this.firebaseStorage})
      : super(GalleryState(
          isLoading: false,
          imageUrls: const [],
          hasError: false,
        )) {
    on<FetchImagesEvent>(_onFetchImages);
  }

  Future<void> _onFetchImages(
      FetchImagesEvent event, Emitter<GalleryState> emit) async {
    emit(state.copyWith(isLoading: true, hasError: false));
    try {
      List<String> imageUrls = await _fetchImageUrls();
      emit(state.copyWith(
        isLoading: false,
        imageUrls: imageUrls,
      ));
    } catch (error) {
      emit(state.copyWith(
        isLoading: false,
        hasError: true,
      ));
    }
  }

  Future<List<String>> _fetchImageUrls() async {
    final ListResult result = await firebaseStorage.ref('images').listAll();
    List<String> imageUrls = [];
    for (Reference ref in result.items) {
      String url = await ref.getDownloadURL();
      imageUrls.add(url);
    }
    return imageUrls;
  }
}
