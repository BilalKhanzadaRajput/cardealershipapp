import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helper/constants/colors_resource.dart';
import '../../../helper/constants/dimensions_resource.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Support',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontSize: Dimensions.FONT_SIZE_LARGE.sp,
            color: ColorResources.WHITE_COLOR,
          ),
        ),
        backgroundColor: ColorResources.PRIMARY_COLOR,
        iconTheme: IconThemeData(color: ColorResources.WHITE_COLOR),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                'Contact Us',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: Dimensions.FONT_SIZE_LARGE.sp,
                  color: ColorResources.PRIMARY_COLOR,
                ),
              ),
              SizedBox(height: 16),
               Text(
                'Email: support@carshowroom.com',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: Dimensions.FONT_SIZE_SMALL.sp,
                  color: ColorResources.BLACK_COLOR,
                ),
              ),
              const SizedBox(height: 8),
               Text(
                'Phone: +1 234 567 8900',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: Dimensions.FONT_SIZE_SMALL.sp,
                  color: ColorResources.BLACK_COLOR,
                ),
              ),
              const SizedBox(height: 16),
               Text(
                'For any other inquiries, please reach out to our support team.',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: Dimensions.FONT_SIZE_SMALL.sp,
                  color: ColorResources.BLACK_COLOR,
                ),
              ),
              const SizedBox(height: 24),

              // Card container for the form
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Name Input Field
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Issue Description Input Field
                      TextField(
                        controller: _issueController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Describe your issue',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        ),
                      ),
                      SizedBox(height: 24),

                      // Submit Button
                      ElevatedButton(
                        onPressed: () {
                          // Dummy functionality to show form data
                          final name = _nameController.text;
                          final issue = _issueController.text;

                          if (name.isEmpty || issue.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Please fill in all fields.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // Simulate submission success
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Support Request Submitted'),
                                content: Text('Your request has been submitted.\n\nName: $name\nIssue: $issue'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );

                            // Clear text fields after submission
                            _nameController.clear();
                            _issueController.clear();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorResources.PRIMARY_COLOR,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 15.h),
                        ),
                        child: Text('Submit',   style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL.sp,
                          color: ColorResources.WHITE_COLOR,
                        ),),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
