import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_bloc.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_event.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_state.dart';
import '../../../helper/constants/colors_resource.dart';

class AddCarScreen extends StatefulWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  final ImagePicker _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCarBloc(),
      child: BlocConsumer<AddCarBloc, AddCarState>(
        listener: (context, state) {
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Car added successfully!')),
            );
            Navigator.pop(context);
          }
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Add Car'),
              backgroundColor: ColorResources.PRIMARY_COLOR,
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Car Model
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Car Model',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) =>
                        context.read<AddCarBloc>().add(UpdateCarModel(value)),
                  ),
                  SizedBox(height: 16.h),

                  // Car Make
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Car Make',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) =>
                        context.read<AddCarBloc>().add(UpdateCarMake(value)),
                  ),
                  SizedBox(height: 16.h),

                  // Year and Price
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Year',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              context.read<AddCarBloc>().add(UpdateYear(value)),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) =>
                              context.read<AddCarBloc>().add(UpdatePrice(value)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Mileage
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Mileage',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) =>
                        context.read<AddCarBloc>().add(UpdateMileage(value)),
                  ),
                  SizedBox(height: 16.h),

                  // Transmission and Fuel Type
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Transmission',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Automatic', 'Manual']
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (value) => context
                              .read<AddCarBloc>()
                              .add(UpdateTransmission(value ?? '')),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Fuel Type',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Petrol', 'Diesel', 'Hybrid', 'Electric']
                              .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                              .toList(),
                          onChanged: (value) => context
                              .read<AddCarBloc>()
                              .add(UpdateFuelType(value ?? '')),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Description
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) =>
                        context.read<AddCarBloc>().add(UpdateDescription(value)),
                  ),
                  SizedBox(height: 16.h),

                  // Add Photos
                  ElevatedButton(
                    onPressed: state.photoUrls.length < 4
                        ? () => _pickImage(context)
                        : null,
                    child: Text('Add Photos (${state.photoUrls.length}/4)'),
                  ),
                  SizedBox(height: 16.h),

                  // Display Images
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: state.photoUrls
                        .map((url) => Stack(
                      children: [
                        Image.network(
                          url,
                          width: 100.w,
                          height: 100.w,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: Icon(Icons.close),
                            onPressed: () => context
                                .read<AddCarBloc>()
                                .add(RemovePhoto(url)),
                          ),
                        ),
                      ],
                    ))
                        .toList(),
                  ),
                  SizedBox(height: 24.h),

                  // Submit Button
                  ElevatedButton(
                    onPressed: state.carModel.isNotEmpty &&
                        state.carMake.isNotEmpty &&
                        state.year.isNotEmpty &&
                        state.price.isNotEmpty &&
                        state.photoUrls.isNotEmpty &&
                        !state.isLoading
                        ? () => context.read<AddCarBloc>().add(SubmitCar())
                        : null,
                    child: Text(
                      'Add Car',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.PRIMARY_COLOR,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
  Future<void> _pickImage(BuildContext context) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      // Assuming you have a method to generate or obtain a URL for the image.
      final String imageUrl = pickedFile.path; // This can be a local file path or a URL.

      // Add the photo URL to the state and optionally store it in Firestore
      context.read<AddCarBloc>().add(AddPhoto(imageUrl));

      // Store the image URL in Firestore
      _storeCarDataInFirestore(
        context.read<AddCarBloc>().state.carModel,
        context.read<AddCarBloc>().state.carMake,
        context.read<AddCarBloc>().state.year,
        context.read<AddCarBloc>().state.price,
        context.read<AddCarBloc>().state.mileage,
        context.read<AddCarBloc>().state.transmission,
        context.read<AddCarBloc>().state.fuelType,
        context.read<AddCarBloc>().state.description,
        imageUrl,
      );
    }
  }


  Future<void> _storeCarDataInFirestore(
      String carModel,
      String carMake,
      String year,
      String price,
      String mileage,
      String transmission,
      String fuelType,
      String description,
      String imageUrl, // The image URL is passed directly
      ) async {
    try {
      final carData = {
        'carModel': carModel,
        'carMake': carMake,
        'year': year,
        'price': price,
        'mileage': mileage,
        'transmission': transmission,
        'fuelType': fuelType,
        'description': description,
        'photoUrls': FieldValue.arrayUnion([imageUrl]), // Store the image URL directly
      };

      // Store the car data in the "cars" collection
      await FirebaseFirestore.instance.collection('cars').add(carData);

      // Optionally, show a success message or handle success logic.
    } catch (error) {
      // Handle error, e.g., show an error message
      print('Error adding car data to Firestore: $error');
    }
  }


  Future<String> _uploadImageToFirebase(XFile image) async {
    // Simulating a delay for the image upload process.
    await Future.delayed(Duration(seconds: 2));

    // Simulating the creation of a fake image URL.
    final String fakeUrl = "https://example.com/${image.name}";

    // Optionally, upload to another server or service here.
    // For now, we return the fake URL, as you're not using Firebase Storage.

    return fakeUrl;
  }

}
