import 'dart:convert';
import 'dart:typed_data' as td;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../helper/constants/colors_resource.dart';
import '../../../helper/constants/dimensions_resource.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../helper/constants/image_resources.dart';

class CarDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> carData;

  const CarDetailsScreen({Key? key, required this.carData}) : super(key: key);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  // Function to launch WhatsApp with the provided phone number
  Future<void> _openWhatsApp(String phoneNumber) async {
    final String whatsappUrl = 'https://wa.me/$phoneNumber';
    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open WhatsApp')),
      );
    }
  }

  // Function to show the full image
  void _showFullImage(td.Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.black,
              child: Center(
                child: Image.memory(
                  imageBytes,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic>? photoUrls = widget.carData['photoUrls'];
    final bool hasMultipleImages = photoUrls != null && photoUrls.length > 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.carData['carMake']} ${widget.carData['carModel']}',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE.sp,
                color: ColorResources.WHITE_COLOR,
              ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: ColorResources.PRIMARY_COLOR,
        iconTheme: IconThemeData(
            color:
                ColorResources.WHITE_COLOR), // Set the back icon color to white
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image slider or single image
            if (photoUrls?.isNotEmpty ?? false)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: hasMultipleImages
                    ? CarouselSlider(
                        options: CarouselOptions(
                          height: 250,
                          autoPlay: true,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: true,
                          aspectRatio: 16 / 9,
                        ),
                        items: photoUrls!.map<Widget>((imageData) {
                          td.Uint8List imageBytes = base64Decode(imageData);
                          return GestureDetector(
                            onTap: () => _showFullImage(imageBytes),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                imageBytes,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text('Image loading failed'),
                                  );
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : GestureDetector(
                        onTap: () {
                          td.Uint8List imageBytes =
                              base64Decode(photoUrls!.first);
                          _showFullImage(imageBytes);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            base64Decode(photoUrls!.first),
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text('Image loading failed'),
                              );
                            },
                          ),
                        ),
                      ),
              ),

            // Car details card
            _buildCard(
              prefixIconSvgPath:
                  ImageResources.CAR_ICON, // Path to your SVG asset
              iconSize: 20.h,

              children: [
                Center(
                  child: Text(
                    '${widget.carData['carMake']} ${widget.carData['carModel']} (${widget.carData['year']})',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontSize: Dimensions.FONT_SIZE_LARGE.sp,
                          color: ColorResources.BLACK_COLOR,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            _buildCard(
              prefixIconSvgPath:
                  ImageResources.PRICE_ICON, // Path to your SVG asset
              iconSize: 20.h,

              children: [
                Center(
                  child: Text(
                    'Price: Rs. ${widget.carData['price']}',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE.sp,
                      color: ColorResources.BLACK_COLOR,
                    ),
                  ),
                ),
              ],
            ),

            Center(
              child: Text(
                'Car Features',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE.sp,
                  color: ColorResources.PRIMARY_COLOR,
                ),
              ),
            ),

            // Car features card
            _buildCard(
              prefixIconSvgPath:
                  ImageResources.FEATURES_ICON, // Path to your SVG asset
              iconSize: 20.h,

              children: [


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFeature(
                      icon: Icons.speed,

                      label: '${widget.carData['mileage']} km',
                    ),
                    _buildFeature(
                      icon: Icons.settings,
                      label: widget.carData['transmission'],
                    ),
                    _buildFeature(
                      icon: Icons.local_gas_station,
                      label: widget.carData['fuelType'],
                    ),
                  ],
                ),
              ],
            ),

            Center(
              child: Text(
                'Showroom Details',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE.sp,
                  color: ColorResources.PRIMARY_COLOR,
                ),
              ),
            ),

            // Showroom details card
            _buildCard(
              prefixIconSvgPath:
                  ImageResources.STORE_ICON, // Path to your SVG asset
              iconSize: 20.h,

              children: [

                const SizedBox(height: 8),
                Center(
                  child: Text(
                    widget.carData['showroomName'] ?? 'N/A',  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE.sp,
                    color: ColorResources.BLACK_COLOR,
                  ),
                  ),
                ),

              ],
            ),

            _buildCard(
              prefixIconSvgPath:
              ImageResources.LOCATION_ICON, // Path to your SVG asset
              iconSize: 20.h,

              children: [
                Center(
                  child: Text(
                    widget.carData['location'] ?? 'N/A',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: Dimensions.FONT_SIZE_LARGE.sp,
                      color: ColorResources.BLACK_COLOR,
                    ),
                  ),
                ),
              ],
            ),



            const SizedBox(height: 16),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final phoneNumber = widget.carData['phoneNumber'];
          if (phoneNumber != null && phoneNumber.isNotEmpty) {
            _openWhatsApp(phoneNumber);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Phone number is not available')),
            );
          }
        },
        backgroundColor: Colors.green,
        child: FaIcon(
          FontAwesomeIcons.whatsapp,
          color: Colors.white,
        ),
      ),
    );
  }

  // Helper method to build a feature widget
  Widget _buildFeature({required IconData icon, required String label}) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blueGrey[700]),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.blueGrey[700],
          ),
        ),
      ],
    );
  }

  // Helper method to build a card widget

  Widget _buildCard({
    required List<Widget> children,
    String? prefixIconSvgPath, // Path to the SVG icon
    double? iconSize = 24, // Default icon size
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (prefixIconSvgPath != null)
                Row(
                  children: [
                    SvgPicture.asset(
                      prefixIconSvgPath,
                      width: iconSize,
                      height: iconSize,
                    ),
                    const SizedBox(
                        width: 8), // Spacing between icon and content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children,
                      ),
                    ),
                  ],
                )
              else
                ...children,
            ],
          ),
        ),
      ),
    );
  }
}
