import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


part 'search_screen_event.dart';
part 'search_screen_state.dart';

class SearchScreenBloc extends Bloc<SearchScreenEvent, SearchScreenState> {
  final FirebaseFirestore _firestore;

  SearchScreenBloc(this._firestore) : super(SearchScreenState()) {
    on<SearchDataEvent>(_onSearchData);
  }

  void _onSearchData(SearchDataEvent event,
      Emitter<SearchScreenState> emit) async {
    print('Searching for: ${event.query}');
    emit(SearchScreenState.loading());
    try {
      if (event.query.isEmpty) {
        emit(SearchScreenState.failure()); // Empty query
      } else {
        final docSnapshot = await _firestore.collection('information').doc(
            'user1').get();
        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          final cnic = data['cnic'].toString();

          if (event.query.length >= 3 && cnic.contains(event.query)) {
            print('Match found: $cnic');
            emit(SearchScreenState.success([data]));
          } else {
            print('No match found for query: ${event.query}');
            emit(SearchScreenState.failure()); // No match found
          }
        } else {
          print('Document does not exist');
          emit(SearchScreenState.failure());
        }
      }
    } catch (e) {
      print('Error: $e');
      emit(SearchScreenState.failure());
    }
  }
}