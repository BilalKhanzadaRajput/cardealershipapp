import 'dart:convert';
import 'dart:typed_data' as td;

import 'package:cardealershipapp/businessLogic/bloc/DashboardScreenBloc/dashboard_screen_bloc.dart';
import 'package:cardealershipapp/presentation/routes/routes_name.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../helper/constants/colors_resource.dart';
import '../../../helper/constants/dimensions_resource.dart';
import '../../../helper/constants/image_resources.dart';
import '../../../helper/constants/screen_percentage.dart';
import '../../../helper/constants/string_resources.dart';
import '../carDetailsScreen/car_details_screen.dart';

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

                          return CarouselSlider.builder(
                            itemCount: snapshot.data!.docs.length,
                            options: CarouselOptions(
                              height: 200.h,
                              aspectRatio: 16 / 9,
                              enlargeCenterPage: true,
                              autoPlay: snapshot.data!.docs.length > 1,
                              enableInfiniteScroll:
                              snapshot.data!.docs.length > 1,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                              scrollPhysics: snapshot.data!.docs.length > 1
                                  ? const BouncingScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                            ),
                            itemBuilder: (BuildContext context, int index,
                                int realIndex) {
                              final carData = snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              String imageData = carData['photoUrls'][0];
                              td.Uint8List imageBytes = base64Decode(imageData);
                              return InkWell(
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CarDetailsScreen(carData: carData),
                                    ),
                                  ),
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    image: DecorationImage(
                                      image: MemoryImage(imageBytes),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 10.w, bottom: 10.h),
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
                                      '${carData['carMake']} ${carData['carModel']} ${carData['year']}',
                                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                        fontSize: Dimensions.FONT_SIZE_LARGE.sp,
                                        color: ColorResources.WHITE_COLOR,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of items per row
                              crossAxisSpacing:
                                  16.w, // Horizontal spacing between grid items
                              mainAxisSpacing:
                                  16.h, // Vertical spacing between grid items
                              childAspectRatio:
                                  0.75, // Adjust this to control the aspect ratio of the grid items
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final carData = snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CarDetailsScreen(carData: carData),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    // Remove additional margin, as spacing is managed by the grid
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (carData['photoUrls']
                                                  ?.isNotEmpty ??
                                              false)
                                            SizedBox(
                                              height: 120.h,
                                              // Adjust height for grid view
                                              child: PageView.builder(
                                                itemCount:
                                                    carData['photoUrls'].length,
                                                itemBuilder:
                                                    (context, photoIndex) {
                                                  if (kDebugMode) {
                                                    print(
                                                      'Photo Index: $photoIndex');
                                                  }
                                                  String imageData =
                                                      carData['photoUrls']
                                                          [photoIndex];
                                                  if (kDebugMode) {
                                                    print(
                                                      'Image Data: $imageData');
                                                  }
                                                  td.Uint8List imageBytes =
                                                      base64Decode(imageData);
                                                  if (kDebugMode) {
                                                    print(
                                                      'Image Bytes: $imageBytes');
                                                  }
                                                  return Image.memory(
                                                    imageBytes,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      if (kDebugMode) {
                                                        print('Error: $error');
                                                      }
                                                      return Text(
                                                          '=========> $error');
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          Padding(
                                            padding: EdgeInsets.all(5.h),
                                            // Adjust padding for grid view
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${carData['carMake']} ${carData['carModel']} ${carData['year']}',
                                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL.sp,
                                                    color: ColorResources.BLACK_COLOR,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis, // Ensure text fits within grid items
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  'Price: Rs. ${carData['price']}',
                                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL.sp,
                                                    color: ColorResources.PRIMARY_COLOR,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Row(
                                                  children: [
                                                    Icon(Icons.speed,
                                                        size: 12.sp),
                                                    SizedBox(width: 4.w),
                                                    Text(
                                                        '${carData['mileage']} km',
                                                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                                        fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL.sp,
                                                        color: ColorResources.BLACK_COLOR,
                                                      ),),
                                                  ],
                                                ),
                                                SizedBox(height: 4.h),
                                                Row(
                                                  children: [
                                                    Icon(Icons.settings,
                                                        size: 12.sp),
                                                    SizedBox(width: 4.w),
                                                    Text(
                                                        carData['transmission'],
                                                        style: TextStyle(
                                                            fontSize: 10.sp)),
                                                  ],
                                                ),
                                                // SizedBox(height: 4.h),
                                                // Row(
                                                //   children: [
                                                //     Icon(
                                                //         Icons.local_gas_station,
                                                //         size: 12.sp),
                                                //     SizedBox(width: 4.w),
                                                //     Text(carData['fuelType'],
                                                //         style: TextStyle(
                                                //             fontSize: 10.sp)),
                                                //   ],
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ));
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
          // App Logo
          Padding(
            padding: EdgeInsets.only(
              top: Dimensions.PADDING_SIZE_EXTRA_LARGE.h,
            ),
            child: Center(
             child:  Padding(
                padding: EdgeInsets.symmetric(
                    vertical: ScreenPercentage.SCREEN_SIZE_7.sw),
                child: Image(
                  image: const AssetImage(ImageResources.APP_LOGO_IMAGE),
                  width: Dimensions.D_200.w,
                  height: Dimensions.D_200.h,
                ),
              ),
            ),
          ),

          // // Close Icon Button
          // Padding(
          //   padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL.h),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       IconButton(
          //         icon: Icon(Icons.close, color: ColorResources.WHITE_COLOR),
          //         onPressed: () {
          //           Navigator.pop(context);
          //         },
          //       ),
          //     ],
          //   ),
          // ),

          // List of Drawer Items
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
                buildDrawerItem(
                  context,
                  icon: Icons.article_outlined,  // Blog Icon
                  text: 'Blog',  // Text for the Blog section
                  onTap: () => Navigator.pushNamed(context, RoutesName.BLOG_SCREEN),  // Navigate to Blog screen
                ),      buildDrawerItem(
                  context,
                  icon: Icons.info_outline_rounded,  // Blog Icon
                  text: 'FAQS',  // Text for the Blog section
                  onTap: () => Navigator.pushNamed(context, RoutesName.FAQS_SCREEN),  // Navigate to Blog screen
                ),   buildDrawerItem(
                  context,
                  icon: Icons.support_outlined,  // Blog Icon
                  text: 'Support',  // Text for the Blog section
                  onTap: () => Navigator.pushNamed(context, RoutesName.SUPPORT_SCEEN),  // Navigate to Blog screen
                ),
              ],
            ),
          ),

          // Logout Option
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
