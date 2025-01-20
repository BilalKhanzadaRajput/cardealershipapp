import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cardealershipapp/helper/constants/colors_resource.dart';
import 'package:cardealershipapp/helper/constants/dimensions_resource.dart';

import '../../../businessLogic/bloc/ComplaintScreenBloc/complaint_screen_bloc.dart';
import '../../../dataProvider/models/complaint_model.dart';



class ComplaintScreen extends StatefulWidget {
  const ComplaintScreen({super.key});

  @override
  State<ComplaintScreen> createState() => _ComplaintScreenState();
}

class _ComplaintScreenState extends State<ComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    context.read<ComplaintScreenBloc>().add(FetchComplaintsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorResources.WHITE_COLOR,
        ),
        centerTitle: true,
        title: Text('Complaints', style: TextStyle(color: ColorResources.WHITE_COLOR),),
        backgroundColor:ColorResources.PRIMARY_COLOR,
      ),
      body: BlocConsumer<ComplaintScreenBloc, ComplaintScreenState>(
        listener: (context, state) {
          if (state.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? ''),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator()); }
          else  {
            return ListView.builder(
              itemCount: state.complaint.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(Dimensions.D_8.h),
                  padding: EdgeInsets.all(Dimensions.D_16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.D_12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(0, 4), // Shadow offset
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              state.complaint[index].title,
                              style: TextStyle(
                                fontSize: Dimensions.D_20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          SizedBox(width: Dimensions.D_8.w), // Space between title and date
                          Text(
                            'Date: ${state.complaint[index].date}',
                            style: TextStyle(
                              fontSize: Dimensions.D_14.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.D_12.h),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.blue, size: Dimensions.D_16.sp),
                          SizedBox(width: Dimensions.D_4.w),
                          Expanded(
                            child: Text(
                              'Location: ${state.complaint[index].location}',
                              style: TextStyle(
                                fontSize: Dimensions.D_14.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.D_16.h),
                      Text(
                        state.complaint[index].description,
                        style: TextStyle(
                          fontSize: Dimensions.D_16.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final bloc = context.read<ComplaintScreenBloc>();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Add a Complaint',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: ColorResources.PRIMARY_COLOR,
                  ),
                ),
                content: SingleChildScrollView(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(
                              labelText: 'Complaint Title',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a complaint title';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: Dimensions.D_16.h),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Complaint Description',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a complaint description';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: Dimensions.D_16.h),
                          TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              labelText: 'Location',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the location';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: Dimensions.D_16.h),
                          TextFormField(
                            controller: _dateController,
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the date';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          bloc.add(
                            AddComplaintEvent(
                              Complaint(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                location: _locationController.text,
                                date: _dateController.text,
                                userId: userId,

                              ),

                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorResources.PRIMARY_COLOR,
                      ),
                      child: Text('Post Complaint', style: TextStyle(color: ColorResources.WHITE_COLOR),),
                    ),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: ColorResources.PRIMARY_COLOR,
        child: const Icon(Icons.add),
      ),    );
  }
}

