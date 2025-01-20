import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cardealershipapp/helper/constants/image_resources.dart';
import 'package:cardealershipapp/helper/constants/string_resources.dart';

part 'dashboard_screen_event.dart';
part 'dashboard_screen_state.dart';

class DashBoardScreenBloc extends Bloc<DashBoardScreenEvent, DashBoardScreenState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DashBoardScreenBloc()
      : super(DashBoardScreenState(
          isLoading: false,
          images: [],
          activeIndex: 0,
          hasError: false,
        )) {
    on<FetchImagesEvent>(_onFetchImages);
    on<UpdateActiveIndexEvent>(_onUpdateActiveIndex);
    on<LogOutUser>(_onLogOutUser);
  }

  Future<void> _onFetchImages(
      FetchImagesEvent event, Emitter<DashBoardScreenState> emit) async {
    emit(state.copyWith(isLoading: true, hasError: false));
    try {
      List<String> texts = StringResources.BHUTTO_FAMILY_VISITS;
      List<String> images = ImageResources.IMAGE_LIST;

      if (texts.length != images.length) {
        // Handle the case where lengths don't match
        print('Error: Texts and images list lengths do not match');
        emit(state.copyWith(isLoading: false, hasError: true));
        return;
      }

      List<Map<String, String>> imageList = List.generate(
        texts.length,
        (index) => {
          'image': images[index],
          'text': texts[index],
        },
      );

      emit(
          state.copyWith(isLoading: false, images: imageList, hasError: false));
    } catch (e) {
      print('Error: $e');
      emit(state.copyWith(isLoading: false, hasError: true));
    }
  }


  Future<void> _onUpdateActiveIndex(
      UpdateActiveIndexEvent event, Emitter<DashBoardScreenState> emit) async {
    emit(state.copyWith(activeIndex: event.index));
  }

  Future<void> _onLogOutUser(LogOutUser event, Emitter<DashBoardScreenState> emit) async {
    emit(state.copyWith(logOutUser: true));
    await _auth.signOut();
    emit(state.copyWith(logOutUser: false));
  }
}
