import 'dart:convert';
import 'dart:io';
import 'dart:typed_data' as td;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_bloc.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_event.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_state.dart';
import '../../../helper/constants/colors_resource.dart';
import '../../../helper/constants/dimensions_resource.dart';

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
              title:  Text('Add Car Details',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE.sp,
            color: ColorResources.WHITE_COLOR,
          ),),
              backgroundColor: ColorResources.PRIMARY_COLOR,
              iconTheme: IconThemeData(color: ColorResources.WHITE_COLOR), // Set the back icon color to white

              centerTitle: true,
            ),
            body: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              padding: EdgeInsets.all(16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Car Model
                  buildTextField(
                    label: 'Car Model',
                    onChanged: (value) => context
                        .read<AddCarBloc>()
                        .add(UpdateCarModel(value)),
                  ),
                  SizedBox(height: 16.h),

                  // Car Make
                  buildTextField(
                    label: 'Car Make',
                    onChanged: (value) => context
                        .read<AddCarBloc>()
                        .add(UpdateCarMake(value)),
                  ),
                  SizedBox(height: 16.h),

                  // Year and Price
                  Row(
                    children: [
                      Expanded(
                        child: buildTextField(
                          label: 'Year',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => context
                              .read<AddCarBloc>()
                              .add(UpdateYear(value)),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: buildTextField(
                          label: 'Price',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => context
                              .read<AddCarBloc>()
                              .add(UpdatePrice(value)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Mileage
                  buildTextField(
                    label: 'Mileage',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => context
                        .read<AddCarBloc>()
                        .add(UpdateMileage(value)),
                  ),

                  SizedBox(height: 16.h),

                  // Transmission and Fuel Type
                  Row(
                    children: [
                      Expanded(
                        child: buildDropdown(
                          label: 'Transmission',
                          items: ['Automatic', 'Manual'],
                          onChanged: (value) => context
                              .read<AddCarBloc>()
                              .add(UpdateTransmission(value ?? '')),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: buildDropdown(
                          label: 'Fuel Type',
                          items: ['Petrol', 'Diesel', 'Hybrid', 'Electric'],
                          onChanged: (value) => context
                              .read<AddCarBloc>()
                              .add(UpdateFuelType(value ?? '')),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Phone Number
                  buildTextFieldForNumber(
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      if (value.startsWith('+92')) {
                        context.read<AddCarBloc>().add(UpdatePhoneNumber(value));
                      }
                    },
                    hintText: 'Enter phone number with +92',
                    errorText: state.phoneNumber.isNotEmpty && !state.phoneNumber.startsWith('+92')
                        ? 'Phone number must start with +92'
                        : null,
                  ),

                  SizedBox(height: 16.h),
                  //location
                  buildTextField(
                    label: 'Location',
                    onChanged: (value) => context
                        .read<AddCarBloc>()
                        .add(UpdateLocation(value)),
                  ),
                  SizedBox(height: 16.h),

                  // Description
                  buildTextField(
                    label: 'Description',
                    maxLines: 3,
                    onChanged: (value) => context
                        .read<AddCarBloc>()
                        .add(UpdateDescription(value)),
                  ),
                  SizedBox(height: 16.h),

                  // Add Photos
                  ElevatedButton(
                    onPressed: state.photoUrls.length < 4
                        ? () => _pickImage(context)
                        : null,
                    child: Text(
                      'Add Photos (${state.photoUrls.length}/4)',
                      style: const TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.PRIMARY_COLOR,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Display Images
                  // Display Images
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: state.photoUrls
                        .map((url) => Stack(
                      children: [
                        Image.file(
                          File(url), // Use Image.file for local image paths
                          width: 100.w,
                          height: 100.w,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            onPressed: () =>
                                context.read<AddCarBloc>().add(RemovePhoto(url)),
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
                        state.location.isNotEmpty &&
                        state.phoneNumber.isNotEmpty &&
                        state.photoUrls.isNotEmpty &&
                        !state.isLoading
                        ? () =>
                        context.read<AddCarBloc>().add(SubmitCar())
                        : null,
                    child: const Text(
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

  Widget buildTextField({
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,

        border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.RADIUS_EXTRA_LARGE.r),

    ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

  Widget buildDropdown({
    required String label,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,

        border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.RADIUS_EXTRA_LARGE.r),

    ),
      ),
      items: items
          .map((e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedFile != null) {
      final String imageUrl = pickedFile.path;
      context.read<AddCarBloc>().add(AddPhoto(imageUrl));
    }
  }
  Widget buildTextFieldForNumber({
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    required Function(String) onChanged,
    String? hintText,
    String? errorText,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_EXTRA_LARGE.r),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

}
