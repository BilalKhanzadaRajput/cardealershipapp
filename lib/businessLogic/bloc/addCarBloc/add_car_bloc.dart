import 'dart:convert';
import 'dart:io';
import 'dart:typed_data' as td;
import 'package:cardealershipapp/businessLogic/bloc/addCarBloc/add_car_event.dart';
import 'package:cardealershipapp/businessLogic/bloc/addCarBloc/add_car_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../dataProvider/models/car_model.dart';

class AddCarBloc extends Bloc<AddCarEvent, AddCarState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AddCarBloc() : super(const AddCarState()) {
    on<UpdateCarModel>((event, emit) {
      print('Updating car model: ${event.carModel}');
      emit(state.copyWith(carModel: event.carModel));
    });
    on<UpdateCarMake>((event, emit) {
      print('Updating car make: ${event.carMake}');
      emit(state.copyWith(carMake: event.carMake));
    });
    on<UpdateYear>((event, emit) {
      print('Updating year: ${event.year}');
      emit(state.copyWith(year: event.year));
    });
    on<UpdatePrice>((event, emit) {
      print('Updating price: ${event.price}');
      emit(state.copyWith(price: event.price));
    });
    on<UpdateMileage>((event, emit) {
      print('Updating mileage: ${event.mileage}');
      emit(state.copyWith(mileage: event.mileage));
    });
    on<UpdateTransmission>((event, emit) {
      print('Updating transmission: ${event.transmission}');
      emit(state.copyWith(transmission: event.transmission));
    });
    on<UpdateFuelType>((event, emit) {
      print('Updating fuel type: ${event.fuelType}');
      emit(state.copyWith(fuelType: event.fuelType));
    });
    on<UpdatePhoneNumber>((event, emit) {
      print('Updating phone number: ${event.phoneNumber}');
      emit(state.copyWith(phoneNumber: event.phoneNumber));
    });
    on<UpdateLocation>((event, emit) {
      print('Updating location : ${event.location}');
      emit(state.copyWith(location: event.location));
    });

    on<UpdateDescription>((event, emit) {
      print('Updating description: ${event.description}');
      emit(state.copyWith(description: event.description));
    });
    on<AddPhoto>((event, emit) {
      print('Adding photo URL: ${event.photoUrl}');
      if (state.photoUrls.length < 4) {
        final List<String> updatedPhotos = List.from(state.photoUrls)
          ..add(event.photoUrl);
        emit(state.copyWith(photoUrls: updatedPhotos));
        print('Photo added successfully. Updated photo list: $updatedPhotos');
      } else {
        print('Photo limit reached. Cannot add more photos.');
      }
    });
    on<RemovePhoto>((event, emit) {
      print('Removing photo URL: ${event.photoUrl}');
      final List<String> updatedPhotos = List.from(state.photoUrls)
        ..remove(event.photoUrl);
      emit(state.copyWith(photoUrls: updatedPhotos));
      print('Photo removed successfully. Updated photo list: $updatedPhotos');
    });
    on<SubmitCar>(_onSubmitCar);
  }

  Future<void> _onSubmitCar(SubmitCar event, Emitter<AddCarState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    print('Submitting car data...');
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');
      print('User authenticated: ${user.uid}');

      // Get showroom details
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (!userDoc.exists) throw Exception('User document not found');
      print('User document found.');

      final userData = userDoc.data()!;
      if (!userData['isShowroomOwner'])
        throw Exception('User is not a showroom owner');
      print('User is a showroom owner.');

      // Validate required fields
      if (state.carModel.isEmpty) throw Exception('Car model is required');
      if (state.carMake.isEmpty) throw Exception('Car make is required');
      if (state.year.isEmpty) throw Exception('Year is required');
      if (state.price.isEmpty) throw Exception('Price is required');
      if (state.location.isEmpty) throw Exception('location is required');
      if (state.photoUrls.isEmpty)
        throw Exception('At least one photo is required');
      print('All required fields validated.');
      List<String> encodedImages = [];

      for (var url in state.photoUrls) {
        td.Uint8List imageBytes = await File(url).readAsBytes();
        String encodedImage = base64Encode(imageBytes);
        encodedImages.add(encodedImage);
      }
      final carRef = _firestore.collection('cars').doc();
      final car = CarModel(
        id: carRef.id,
        location: state.location,
        showroomId: user.uid,
        showroomName: userData['showroomName'] ?? '',
        carModel: state.carModel,
        phoneNumber:state.phoneNumber,
        carMake: state.carMake,
        year: state.year,
        price: state.price,
        mileage: state.mileage,
        transmission: state.transmission,
        fuelType: state.fuelType,
        photoUrls: encodedImages,
        description: state.description,

        createdAt: DateTime.now(),
      );



      print('Creating car document with ID: ${carRef.id}');
      await carRef.set(car.toMap());
      print('Car document created successfully.');

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      print('Error submitting car data: $e');
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
}
