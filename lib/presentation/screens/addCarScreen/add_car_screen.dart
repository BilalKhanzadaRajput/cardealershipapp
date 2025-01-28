import 'dart:io';
import 'package:cardealershipapp/helper/extension/strings_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_bloc.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_event.dart';
import '../../../businessLogic/bloc/addCarBloc/add_car_state.dart';
import '../../../helper/constants/colors_resource.dart';
import '../../../helper/constants/dimensions_resource.dart';
import '../../../helper/constants/image_resources.dart';
import '../../../helper/constants/string_resources.dart';
import '../../customWidgets/custom_text_field.dart';

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
              title: Text(
                'Add Car Details',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE.sp,
                  color: ColorResources.WHITE_COLOR,
                ),
              ),
              backgroundColor: ColorResources.PRIMARY_COLOR,
              iconTheme: IconThemeData(color: ColorResources.WHITE_COLOR),
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
                  CustomTextFormField(
                    hintText: 'Car Model',
                    onChanged: (value) => context
                        .read<AddCarBloc>()
                        .add(UpdateCarModel(value)),
                    prefixIconSvgPath: ImageResources.CAR_ICON,
                  ),
                  SizedBox(height: 16.h),

                  // Car Make
                  CustomTextFormField(
                    hintText: 'Car Make',
                    onChanged: (value) => context
                        .read<AddCarBloc>()
                        .add(UpdateCarMake(value)),
                    prefixIconSvgPath: ImageResources.CAR_ICON,
                  ),
                  SizedBox(height: 16.h),

                  // Year and Price
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          hintText: 'Year',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => context
                              .read<AddCarBloc>()
                              .add(UpdateYear(value)),
                          prefixIconSvgPath: ImageResources.CALENDER_ICON,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: CustomTextFormField(
                          hintText: 'Price',
                          keyboardType: TextInputType.number,
                          onChanged: (value) => context
                              .read<AddCarBloc>()
                              .add(UpdatePrice(value)),
                          prefixIconSvgPath: ImageResources.PRICE_ICON,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Mileage
                  CustomTextFormField(
                    hintText: 'Mileage',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => context
                        .read<AddCarBloc>()
                        .add(UpdateMileage(value)),
                    prefixIconSvgPath: ImageResources.MILAGE_ICON,
                  ),
                  SizedBox(height: 16.h),

                  // Transmission and Fuel Type
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'Transmission',
                          items: ['Automatic', 'Manual'],
                          onChanged: (value) => context
                              .read<AddCarBloc>()
                              .add(UpdateTransmission(value ?? '')),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildDropdown(
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
                  CustomTextFormField(
                    hintText: StringResources.PHONE_HINT,
                    onChanged: (value) => context
                        .read<AddCarBloc>()
                        .add(UpdatePhoneNumber(value)),
                    validator: (value) =>
                        value.validatePhoneNumber(value),
                    prefixIconSvgPath: ImageResources.PHONE_ICON,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(11),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // Location
                  CustomTextFormField(
                    hintText: 'Location',
                    onChanged: (value) => context
                        .read<AddCarBloc>()
                        .add(UpdateLocation(value)),
                    prefixIconSvgPath: ImageResources.LOCATION_ICON,
                  ),
                  SizedBox(height: 16.h),

                  // Description
                  CustomTextFormField(
                    hintText: 'Description',
                    maxLines: 3,
                    onChanged: (value) => context
                        .read<AddCarBloc>()
                        .add(UpdateDescription(value)),
                    prefixIconSvgPath: ImageResources.DESCRIPTION_ICON,
                  ),
                  SizedBox(height: 16.h),

                  // Add Photos
                  ElevatedButton(
                    onPressed: state.photoUrls.length < 4
                        ? () => _pickImage(context)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorResources.PRIMARY_COLOR,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center, // Centers the content
                      children: [
                        Icon(
                          Icons.camera_alt, // Camera icon
                          color: Colors.white,
                        ),
                        SizedBox(width: 8), // Space between the icon and text
                        Text(
                          'Add Photos (${state.photoUrls.length}/4)',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Display Images
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: state.photoUrls
                        .map((url) => Stack(
                      children: [
                        Image.file(
                          File(url),
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
                        state.location.isNotEmpty &&
                        state.phoneNumber.isNotEmpty &&
                        state.photoUrls.isNotEmpty &&
                        !state.isLoading
                        ? () => context
                        .read<AddCarBloc>()
                        .add(SubmitCar())
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

  Widget _buildDropdown({
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
}
