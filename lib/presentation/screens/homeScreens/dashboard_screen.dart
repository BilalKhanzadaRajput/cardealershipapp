import 'dart:convert';
import 'dart:typed_data' as td;

import 'package:cardealershipapp/businessLogic/bloc/DashboardScreenBloc/dashboard_screen_bloc.dart';
import 'package:cardealershipapp/presentation/routes/routes_name.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../helper/constants/colors_resource.dart';
import '../../../helper/constants/dimensions_resource.dart';
import '../../../helper/constants/image_resources.dart';
import '../../../helper/constants/string_resources.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashBoardScreenBloc>().add(FetchImagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.BACKGROUND_COLOR,
      appBar: AppBar(
        title: Text(
          StringResources.DASHBOARD_TITLE,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE.sp,
                color: ColorResources.WHITE_COLOR,
              ),
        ),
        backgroundColor: ColorResources.PRIMARY_COLOR,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset(
                ImageResources.MENU_ICON,
                width: Dimensions.D_24.w,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: customDrawer(context: context),
      body: BlocListener<DashBoardScreenBloc, DashBoardScreenState>(
        listener: (context, state) {
          if (state.hasError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(StringResources.ERROR_FETCHING_DATA_ERROR),
                backgroundColor: ColorResources.ERROR_RED_COLOR,
              ),
            );
          }
          if (state.logOutUser) {
            Navigator.pushNamedAndRemoveUntil(
                context, RoutesName.LOG_IN_SCREEN, (route) => false);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: BlocBuilder<DashBoardScreenBloc, DashBoardScreenState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state.images.isNotEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: CarouselSlider.builder(
                          itemCount: state.images.length,
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            enlargeCenterPage: true,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            scrollDirection: Axis.horizontal,
                            height: 200.h,
                            scrollPhysics: const BouncingScrollPhysics(),
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            onPageChanged: (index, reason) {
                              context
                                  .read<DashBoardScreenBloc>()
                                  .add(UpdateActiveIndexEvent(index));
                            },
                          ),
                          itemBuilder:
                              (BuildContext context, int index, int realIndex) {
                            final String imagePath =
                                state.images[index]['image']!;
                            final String text = state.images[index]['text']!;

                            return InkWell(
                              onTap: () => {}, // Define action on tap if needed
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image: AssetImage(imagePath),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Container(
                                  padding:
                                      EdgeInsets.only(left: 10.w, bottom: 10.h),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomRight,
                                      colors: [
                                        Colors.black.withOpacity(0.4),
                                        Colors.black.withOpacity(0.2),
                                      ],
                                    ),
                                  ),
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      buildIndicator(state.activeIndex, state.images.length),
                      const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                      // Add Car Listings
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('cars')
                            .orderBy('createdAt', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const Center(
                                child: Text('No cars available'));
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final carData = snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              return Card(
                                margin: EdgeInsets.only(bottom: 16.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (carData['photoUrls']?.isNotEmpty ??
                                        false)
                                      SizedBox(
                                        height: 200.h,
                                        child: PageView.builder(
                                          itemCount:
                                              carData['photoUrls'].length,
                                          itemBuilder: (context, photoIndex) {
                                            print('Photo Index: $photoIndex');
                                            String imageData =
                                                carData['photoUrls']
                                                    [photoIndex];
                                            print('Image Data: $imageData');
                                            td.Uint8List imageBytes =
                                                base64Decode(imageData);
                                            print('Image Bytes: $imageBytes');
                                            return Image.memory(
                                              imageBytes,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                print('Error: $error');
                                                return Text(
                                                    '=========> $error');
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    Padding(
                                      padding: EdgeInsets.all(16.h),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${carData['carMake']} ${carData['carModel']} ${carData['year']}',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'Price: Rs. ${carData['price']}',
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color:
                                                  ColorResources.PRIMARY_COLOR,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Row(
                                            children: [
                                              Icon(Icons.speed, size: 16.sp),
                                              SizedBox(width: 4.w),
                                              Text('${carData['mileage']} km'),
                                              SizedBox(width: 16.w),
                                              Icon(Icons.settings, size: 16.sp),
                                              SizedBox(width: 4.w),
                                              Text(carData['transmission']),
                                              SizedBox(width: 16.w),
                                              Icon(Icons.local_gas_station,
                                                  size: 16.sp),
                                              SizedBox(width: 4.w),
                                              Text(carData['fuelType']),
                                            ],
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            'Showroom: ${carData['showroomName']}',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data?.get('isShowroomOwner') == true) {
            return FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RoutesName.ADD_CAR_SCREEN),
              backgroundColor: ColorResources.PRIMARY_COLOR,
              child: const Icon(Icons.add),
              tooltip: 'Add Car',
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget customDrawer({required BuildContext context}) {
    return Drawer(
      backgroundColor: ColorResources.PRIMARY_COLOR,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.close, color: ColorResources.WHITE_COLOR),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                top: Dimensions.PADDING_SIZE_EXTRA_OVER_LARGE.h,
              ),
              children: [
                buildDrawerItem(
                  context,
                  icon: Icons.home_outlined,
                  text: StringResources.HOME_ICON_TEXT,
                  onTap: () => Navigator.pop(context),
                ),
                buildDrawerItem(
                  context,
                  icon: Icons.person_outline,
                  text: StringResources.PROFILE,
                  onTap: () =>
                      Navigator.pushNamed(context, RoutesName.PROFILE_SCREEN),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: Dimensions.PADDING_8.w,
                bottom: Dimensions.PADDING_SIZE_EXTRA_LARGE.w),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showLogOutDialog(context, () {
                  context.read<DashBoardScreenBloc>().add(LogOutUser());
                });
              },
              child: ListTile(
                leading: Icon(Icons.logout_outlined,
                    color: ColorResources.WHITE_COLOR),
                title: Text(
                  StringResources.LOG_OUT_TEXT,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE.sp,
                        color: ColorResources.WHITE_COLOR,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.only(left: Dimensions.PADDING_8.w),
      child: ListTile(
        leading: Icon(icon, color: ColorResources.WHITE_COLOR),
        title: Text(
          text,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: Dimensions.FONT_SIZE_LARGE.sp,
                color: ColorResources.WHITE_COLOR,
              ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildImage(String urlImage, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.grey,
      child: Image.network(
        urlImage,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildIndicator(int activeIndex, int itemCount) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: itemCount,
      effect: const ScrollingDotsEffect(
        dotWidth: 10,
        dotHeight: 10,
        activeDotColor: ColorResources.PRIMARY_COLOR,
        dotColor: Colors.grey,
      ),
    );
  }

  void showLogOutDialog(BuildContext context, VoidCallback onPressed) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(StringResources.LOGOUT,
            style: TextStyle(color: ColorResources.PRIMARY_COLOR)),
        content: Text(
          StringResources.LOG_OUT_BOX_SUBTITLE,
          style: TextStyle(color: ColorResources.BLACK_COLOR),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(StringResources.CANCEL,
                style: TextStyle(color: ColorResources.BLACK_COLOR)),
          ),
          TextButton(
            onPressed: onPressed,
            child: Text(StringResources.LOGOUT,
                style: TextStyle(color: ColorResources.BLACK_COLOR)),
          ),
        ],
      ),
    );
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.photo_camera_back_outlined; // Icon for Videos
      case 1:
        return Icons.work_outline_outlined; // Icon for Job Announcements
      case 2:
        return Icons.search_outlined; // Icon for Search
      case 3:
        return Icons.feedback_outlined; // Icon for Complaints
      default:
        return Icons.help_outline; // Default icon if index is not matched
    }
  }

  String _getTextForIndex(int index) {
    switch (index) {
      case 0:
        return StringResources.GALLERY_TITLE; // Text for Videos
      case 1:
        return StringResources.JOB_ANNOUCMENTS; // Text for Job Announcements
      case 2:
        return StringResources.SEARCH_TITLE; // Text for Search
      case 3:
        return StringResources.COMPLAINTS; // Text for Complaints
      default:
        return 'Unknown'; // Default text if index is not matched
    }
  }
}
