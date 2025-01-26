import 'package:equatable/equatable.dart';


class AddCarState extends Equatable {
  final String carModel;
  final String carMake;
  final String year;
  final String price;
  final String mileage;
  final String phoneNumber;
  final String location;

  final String transmission;
  final String fuelType;
  final List<String> photoUrls;
  final String description;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const AddCarState({
    this.carModel = '',
    this.carMake = '',
    this.year = '',
    this.phoneNumber = '',
    this.location = '',

    this.price = '',
    this.mileage = '',
    this.transmission = '',
    this.fuelType = '',
    this.photoUrls = const [],
    this.description = '',
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  AddCarState copyWith({
    String? carModel,
    String? carMake,
    String? year,
    String? price,
    String? phoneNumber,
    String? location,

    String? mileage,
    String? transmission,
    String? fuelType,
    List<String>? photoUrls,
    String? description,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AddCarState(
      carModel: carModel ?? this.carModel,
      carMake: carMake ?? this.carMake,
      year: year ?? this.year,
      price: price ?? this.price,
      mileage: mileage ?? this.mileage,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      photoUrls: photoUrls ?? this.photoUrls,
      description: description ?? this.description,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,

    );
  }

  @override
  List<Object?> get props => [
        carModel,
        carMake,
        year,
        price,
        mileage,
        transmission,
        fuelType,
        photoUrls,
        description,
        isLoading,
        errorMessage,
        isSuccess,
    phoneNumber,
    location,

  ];
}