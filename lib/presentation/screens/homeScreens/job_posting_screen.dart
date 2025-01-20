import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cardealershipapp/businessLogic/bloc/jobPostingScreenBloc/job_posting_screen_bloc.dart';
import 'package:cardealershipapp/dataProvider/models/job_announcement_model.dart';
import 'package:cardealershipapp/helper/constants/colors_resource.dart';
import 'package:cardealershipapp/helper/constants/dimensions_resource.dart';


class JobPostingScreen extends StatefulWidget {
  const JobPostingScreen({super.key});

  @override
  State<JobPostingScreen> createState() => _JobPostingScreenState();
}

class _JobPostingScreenState extends State<JobPostingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numberOfPositionsController =
  TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _timingController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    context.read<JobPostingScreenBloc>().add(FetchJobsEvent());
    context.read<JobPostingScreenBloc>().add(IsUserAdmin()); // Fetch if the user is an admin
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _numberOfPositionsController.dispose();
    _roleController.dispose();
    _salaryController.dispose();
    _companyController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: ColorResources.WHITE_COLOR,
        ),
        centerTitle: true,
        title: Text('Job Announcements', style: TextStyle(color: ColorResources.WHITE_COLOR),),
        backgroundColor: ColorResources.PRIMARY_COLOR,
      ),
      body: BlocConsumer<JobPostingScreenBloc, JobPostingScreenState>(
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
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: state.jobs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(Dimensions.D_8.h),
                  padding: EdgeInsets.all(Dimensions.D_16.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Dimensions.D_10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              state.jobs[index].title,
                              style: TextStyle(
                                fontSize: Dimensions.D_18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            state.jobs[index].salary,
                            style: TextStyle(
                              fontSize: Dimensions.D_16.sp,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.D_8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            state.jobs[index].company,
                            style: TextStyle(
                              fontSize: Dimensions.D_14.sp,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            state.jobs[index].location,
                            style: TextStyle(
                              fontSize: Dimensions.D_14.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.D_8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Posted on: ${state.jobs[index].date}',
                            style: TextStyle(
                              fontSize: Dimensions.D_14.sp,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            state.jobs[index].role,
                            style: TextStyle(
                              fontSize: Dimensions.D_14.sp,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.D_16.h),
                      Text(
                        state.jobs[index].description,
                        style: TextStyle(
                          fontSize: Dimensions.D_14.sp,
                          color: Colors.grey,
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
      floatingActionButton: BlocBuilder<JobPostingScreenBloc, JobPostingScreenState>(
        builder: (context, state) {
          if (state.isAdmin) {
            return FloatingActionButton(
              onPressed: () {
                final bloc = context.read<JobPostingScreenBloc>();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'Add a Job',
                        style: TextStyle(
                          fontSize: Dimensions.D_14.sp,
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
                                    labelText: 'Job Title',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a job title';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: Dimensions.D_16.h),
                                TextFormField(
                                  controller: _descriptionController,
                                  maxLines: 3,
                                  decoration: const InputDecoration(
                                    labelText: 'Job Description',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a job description';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: Dimensions.D_16.h),
                                TextFormField(
                                  controller: _numberOfPositionsController,
                                  decoration: const InputDecoration(
                                    labelText: 'Number of Positions',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the number of positions';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: Dimensions.D_16.h),
                                TextFormField(
                                  controller: _roleController,
                                  decoration: const InputDecoration(
                                    labelText: 'Role',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the role';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: Dimensions.D_16.h),
                                TextFormField(
                                  controller: _timingController,
                                  decoration: const InputDecoration(
                                    labelText: 'Timing',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the timing';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: Dimensions.D_16.h),
                                TextFormField(
                                  controller: _salaryController,
                                  decoration: const InputDecoration(
                                    labelText: 'Salary',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the salary';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: Dimensions.D_16.h),
                                TextFormField(
                                  controller: _companyController,
                                  decoration: const InputDecoration(
                                    labelText: 'Company',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter the company';
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
                                  AddJobEvent(
                                    JobAnnouncement(
                                      _titleController.text,
                                      _descriptionController.text,
                                      _numberOfPositionsController.text,
                                      _roleController.text,
                                      _timingController.text,
                                      _salaryController.text,
                                      _companyController.text,
                                      _locationController.text,
                                      _dateController.text,
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorResources.PRIMARY_COLOR,
                            ),
                            child: Text('Post Job Announcement', style: TextStyle(color: ColorResources.WHITE_COLOR),),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: ColorResources.PRIMARY_COLOR,
              child: const Icon(Icons.add),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}