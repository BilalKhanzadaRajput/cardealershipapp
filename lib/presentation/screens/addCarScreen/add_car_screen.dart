import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_bloc.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_event.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_state.dart';
import '../../../helper/constants/colors_resource.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddCarScreen extends StatefulWidget {
  const AddCarScreen({Key? key}) : super(key: key);

  @override
  State<AddCarScreen> createState() => _AddCarScreenState();
}

class _AddCarScreenState extends State<AddCarScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCarBloc(),
      child: const AddCarScreenContent(),
    );
  }
}

class AddCarScreenContent extends StatefulWidget {
  const AddCarScreenContent({Key? key}) : super(key: key);

  @override
  State<AddCarScreenContent> createState() => _AddCarScreenContentState();
}

class _AddCarScreenContentState extends State<AddCarScreenContent> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddCarBloc, AddCarState>(
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
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Car Model',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => context
                            .read<AddCarBloc>()
                            .add(UpdateCarModel(value)),
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Car Make',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => context
                            .read<AddCarBloc>()
                            .add(UpdateCarMake(value)),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Year',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              onChanged: (value) => context
                                  .read<AddCarBloc>()
                                  .add(UpdateYear(value)),
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
                              onChanged: (value) => context
                                  .read<AddCarBloc>()
                                  .add(UpdatePrice(value)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Mileage',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) => context
                            .read<AddCarBloc>()
                            .add(UpdateMileage(value)),
                      ),
                      SizedBox(height: 16.h),
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
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        onChanged: (value) => context
                            .read<AddCarBloc>()
                            .add(UpdateDescription(value)),
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: state.photoUrls.length < 4 
                          ? () => _pickImage(context)
                          : null,
                        child: Text('Add Photos (${state.photoUrls.length}/4)'),
                      ),
                      SizedBox(height: 16.h),
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
    );
  }

Future<void> _pickImage(BuildContext context) async {
  if (!mounted) return;  // Check if the widget is still in the widget tree

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? pickedFile = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 50,
                );
                if (pickedFile != null && mounted) {  // Ensure widget is still mounted
                  print('Image selected from gallery: ${pickedFile.path}');
                  context.read<AddCarBloc>().add(AddPhoto(pickedFile.path));
                } else {
                  print('No image selected from gallery');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final ImagePicker picker = ImagePicker();
                final XFile? pickedFile = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 50,
                );
                if (pickedFile != null && mounted) {  // Ensure widget is still mounted
                  print('Image captured from camera: ${pickedFile.path}');
                  context.read<AddCarBloc>().add(AddPhoto(pickedFile.path));
                } else {
                  print('No image captured from camera');
                }
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _saveImageIdToDatabase(BuildContext context, XFile image) async {
  try {
    print('Attempting to save image: ${image.name}');
    
    // Generate a unique ID for the image
    final String imageId = DateTime.now().millisecondsSinceEpoch.toString();
    print('Generated imageId: $imageId');

    // Save the ID in the Firestore 'images' collection
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    print('Saving image ID to Firestore...');
    await firestore.collection('images').doc(imageId).set({
      'imageId': imageId,
      'fileName': image.name,
      'uploadedAt': DateTime.now().toIso8601String(),
    });

    // Update the AddCarBloc with the new image ID
    print('Image ID saved successfully. Updating AddCarBloc...');
    context.read<AddCarBloc>().add(AddPhoto(imageId));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image ID saved to database successfully')),
    );
    print('Image ID saved to database and AddCarBloc updated successfully.');
  } catch (e) {
    print('Error saving image ID to database: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving image ID to database: $e')),
    );
  }
}
} 