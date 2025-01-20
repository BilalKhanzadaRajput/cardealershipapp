import 'package:cardealershipapp/businessLogic/bloc/profileScreenBloc/profile_screen_bloc.dart';
import 'package:cardealershipapp/businessLogic/bloc/profileScreenBloc/profile_screen_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cardealershipapp/helper/constants/colors_resource.dart';

import '../../../businessLogic/bloc/profileScreenBloc/profile_screen_event.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize profile data if needed
    context.read<ProfileScreenBloc>().add(FetchProfileDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScreenContent();
  }
}

class ProfileScreenContent extends StatelessWidget {
  const ProfileScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            backgroundColor: ColorResources.PRIMARY_COLOR,
            actions: [
              IconButton(
                icon: Icon(state.isEditing ? Icons.save : Icons.edit),
                onPressed: () {
                  if (state.isEditing) {
                    context.read<ProfileScreenBloc>().add(SaveProfile());
                  } else {
                    context.read<ProfileScreenBloc>().add(ToggleEditMode());
                  }
                },
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: ColorResources.PRIMARY_COLOR,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      TextField(
                        controller: TextEditingController(text: state.fullName),
                        enabled: state.isEditing,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => context
                            .read<ProfileScreenBloc>()
                            .add(UpdateFullName(value)),
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        controller: TextEditingController(text: state.email),
                        enabled: false,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextField(
                        controller: TextEditingController(text: state.phoneNumber),
                        enabled: state.isEditing,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) => context
                            .read<ProfileScreenBloc>()
                            .add(UpdatePhoneNumber(value)),
                      ),
                      if (state.isShowroomOwner) ...[
                        SizedBox(height: 16.h),
                        TextField(
                          controller: TextEditingController(text: state.showroomName),
                          enabled: state.isEditing,
                          decoration: InputDecoration(
                            labelText: 'Showroom Name',
                            prefixIcon: Icon(Icons.store),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => context
                              .read<ProfileScreenBloc>()
                              .add(UpdateShowroomName(value)),
                        ),
                      ],
                      if (state.errorMessage != null) ...[
                        SizedBox(height: 16.h),
                        Text(
                          state.errorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }
} 