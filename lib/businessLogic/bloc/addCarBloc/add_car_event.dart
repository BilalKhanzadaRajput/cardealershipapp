import 'package:equatable/equatable.dart';

abstract class AddCarEvent extends Equatable {
  const AddCarEvent();
  
  @override
  List<Object?> get props => [];
}

class UpdateCarModel extends AddCarEvent {
  final String carModel;
  UpdateCarModel(this.carModel);
  @override
  List<Object?> get props => [carModel];
}

class UpdateCarMake extends AddCarEvent {
  final String carMake;
  UpdateCarMake(this.carMake);
  @override
  List<Object?> get props => [carMake];
}

class UpdateYear extends AddCarEvent {
  final String year;
  UpdateYear(this.year);
  @override
  List<Object?> get props => [year];
}

class UpdatePrice extends AddCarEvent {
  final String price;
  UpdatePrice(this.price);
  @override
  List<Object?> get props => [price];
}

class UpdateMileage extends AddCarEvent {
  final String mileage;
  UpdateMileage(this.mileage);
  @override
  List<Object?> get props => [mileage];
}

class UpdateTransmission extends AddCarEvent {
  final String transmission;
  UpdateTransmission(this.transmission);
  @override
  List<Object?> get props => [transmission];
}

class UpdateFuelType extends AddCarEvent {
  final String fuelType;
  UpdateFuelType(this.fuelType);
  @override
  List<Object?> get props => [fuelType];
}

class AddPhoto extends AddCarEvent {
  final String photoUrl;
  AddPhoto(this.photoUrl);
  @override
  List<Object?> get props => [photoUrl];
}

class RemovePhoto extends AddCarEvent {
  final String photoUrl;
  RemovePhoto(this.photoUrl);
  @override
  List<Object?> get props => [photoUrl];
}

class UpdateDescription extends AddCarEvent {
  final String description;
  UpdateDescription(this.description);
  @override
  List<Object?> get props => [description];
}

class SubmitCar extends AddCarEvent {} 