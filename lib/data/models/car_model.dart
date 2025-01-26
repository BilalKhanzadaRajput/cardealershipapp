class CarModel {
  final String id;
  final String showroomId;
  final String showroomName;
  final String carModel;
  final String carMake;
  final String year;
  final String price;
  final String location;
  final String mileage;
  final String transmission;
  final String phoneNumber;
  final String fuelType;
  final List<String> photoUrls;
  final String description;
  final DateTime createdAt;

  CarModel({
    required this.id,
    required this.location,
    required this.showroomId,
    required this.showroomName,
    required this.carModel,
    required this.carMake,
    required this.year,
    required this.price,
    required this.mileage,
    required this.transmission,
    required this.phoneNumber,
    required this.fuelType,
    required this.photoUrls,
    required this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'showroomId': showroomId,
      'location' : location,
      'showroomName': showroomName,
      'carModel': carModel,
      'carMake': carMake,
      'year': year,
      'price': price,
      'mileage': mileage,
      'transmission': transmission,
      'phoneNumber': phoneNumber,
      'fuelType': fuelType,
      'photoUrls': photoUrls,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CarModel.fromMap(Map<String, dynamic> map) {
    return CarModel(
      id: map['id'] ?? '',
      location: map['location'] ?? '',
      showroomId: map['showroomId'] ?? '',
      showroomName: map['showroomName'] ?? '',
      carModel: map['carModel'] ?? '',
      carMake: map['carMake'] ?? '',
      year: map['year'] ?? '',
      price: map['price'] ?? '',
      mileage: map['mileage'] ?? '',
      transmission: map['transmission'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      fuelType: map['fuelType'] ?? '',
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      description: map['description'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
